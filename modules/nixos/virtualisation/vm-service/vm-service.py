import asyncio
import base64
import json
import signal
import stat
from argparse import ArgumentParser
from asyncio import FIRST_COMPLETED, StreamReader, StreamWriter
from enum import Enum, StrEnum
from pathlib import Path


class GuestOS(StrEnum):
    Linux = "linux"
    Windows = "windows"


class VMState(Enum):
    Exited = 0
    Running = 1
    Sleeping = 2


class VMService:
    def __init__(self, vm_boot: Path, vm_directory: Path, guest_os: GuestOS, timeout=300):
        self.VM_BOOT = vm_boot
        self.VM_DIRECTORY = vm_directory
        self.GUEST_OS = guest_os
        self.TIMEOUT = timeout
        self.CAN_HIBERNATE = None

        self.start = asyncio.Event()
        self.terminate = asyncio.Event()
        self.state = VMState.Exited

    async def main(self):
        loop = asyncio.get_running_loop()
        loop.add_signal_handler(signal.SIGUSR1, lambda: self.start.set())
        loop.add_signal_handler(signal.SIGTERM, lambda: self.terminate.set())

        while True:
            task_run = asyncio.create_task(self.run())

            task_monitor_spice = asyncio.create_task(self.monitor_spice())
            task_monitor_terminate = asyncio.create_task(self.terminate.wait())

            done, _pending = await asyncio.wait(
                [task_run, task_monitor_spice, task_monitor_terminate],
                return_when=FIRST_COMPLETED,
            )
            for task in done:
                if exception := task.exception():
                    raise exception
            task_monitor_spice.cancel()

            assert self.terminate.is_set() == (self.state == VMState.Running)
            if self.terminate.is_set():
                print("service is terminating")
                await self.sleep()
                await asyncio.wait([task_run])
                return

            self.start.clear()
            task_monitor_start = asyncio.create_task(self.start.wait())

            done, _pending = await asyncio.wait(
                [task_monitor_start, task_monitor_terminate],
                return_when=FIRST_COMPLETED,
            )
            for task in done:
                if exception := task.exception():
                    raise exception
            task_monitor_start.cancel()

            if self.terminate.is_set():
                print("service is terminating")
                await asyncio.wait([task_run])
                return

            print("received SIGUSR1 signal")

    async def run(self):
        process = await asyncio.create_subprocess_exec(self.VM_BOOT)
        print(f"started vm process with pid {process.pid}")
        self.state = VMState.Running
        exit_code = await process.wait()
        print(f"vm process exited with code {exit_code}")
        self.state = VMState.Exited

    async def monitor_spice(self):
        socket_file = self.VM_DIRECTORY / "monitor.sock"
        for _ in range(5):
            await asyncio.sleep(1)
            if socket_file.exists():
                break
        else:
            raise FileNotFoundError(socket_file)

        reader, writer = await asyncio.open_unix_connection(socket_file)

        timeout = self.TIMEOUT
        POLL = 5
        while timeout > 0:
            await asyncio.sleep(POLL)
            timeout -= POLL

            writer.write(b"info spice\n")
            await writer.drain()

            data = b""
            while True:
                try:
                    data += await asyncio.wait_for(reader.readline(), 0.1)
                except TimeoutError:
                    break

            if b"Channel:" in data:
                timeout = self.TIMEOUT
            elif 0 < (value := timeout % ((self.TIMEOUT - POLL - 1) / 5)) and value < POLL:
                print(f"sending vm to sleep in {timeout} seconds")

        writer.close()
        await writer.wait_closed()

        await self.sleep()

    async def sleep(self):
        if self.CAN_HIBERNATE is None:
            self.CAN_HIBERNATE = await self.check_hibernation_support()

        if self.CAN_HIBERNATE and self.GUEST_OS == GuestOS.Windows:
            print("sending hibernation command to vm")
            reader, writer = await asyncio.open_unix_connection(self.VM_DIRECTORY / "agent.sock")
            await self.qga_guest_exec(reader, writer, ["shutdown", "/h"])
        else:
            print("sending shutdown command to vm")
            reader, writer = await asyncio.open_unix_connection(self.VM_DIRECTORY / "monitor.sock")
            writer.write(b"system_powerdown\n")
            await writer.drain()

        writer.close()
        await writer.wait_closed()

        self.state = VMState.Sleeping

    async def check_hibernation_support(self):
        if self.GUEST_OS != GuestOS.Windows:
            return False

        reader, writer = await asyncio.open_unix_connection(self.VM_DIRECTORY / "agent.sock")
        assert (output := await self.qga_guest_exec(reader, writer, ["powercfg", "/a"], True))
        writer.close()
        await writer.wait_closed()

        return "Hibernate" in output

    @staticmethod
    async def qga_guest_exec(
        reader: StreamReader, writer: StreamWriter, args: list[str], capture_output=False
    ):
        data = {
            "execute": "guest-exec",
            "arguments": {"path": args[0], "arg": args[1:], "capture-output": capture_output},
        }
        writer.write(json.dumps(data).encode() + b"\n")
        await writer.drain()

        response = await reader.readline()

        if capture_output:
            pid = json.loads(response)["return"]["pid"]
            for _ in range(5):
                await asyncio.sleep(1)
                data = {"execute": "guest-exec-status", "arguments": {"pid": pid}}
                writer.write(json.dumps(data).encode() + b"\n")
                await writer.drain()

                response = await reader.readline()
                if out_data := json.loads(response)["return"].get("out-data"):
                    return base64.b64decode(out_data).decode()
            else:
                raise TimeoutError("failed to capture output in time")


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("vm_boot", type=Path)
    parser.add_argument("directory", type=Path)
    parser.add_argument("guest_os", choices=["linux", "windows"])
    parser.add_argument("--timeout", type=int, default=300)
    args = parser.parse_args()

    vm_boot: Path = args.vm_boot
    assert vm_boot.is_file() and (vm_boot.stat().st_mode & stat.S_IXUSR)
    directory: Path = args.directory
    assert directory.is_dir()

    service = VMService(args.vm_boot, args.directory, GuestOS(args.guest_os), timeout=args.timeout)
    asyncio.run(service.main())
