import shutil, sys
from getpass import getpass
from hashlib import md5
from pathlib import Path
from subprocess import CalledProcessError, check_call, check_output

from cutie import prompt_yes_or_no, select
from error_helper import *
from git import Repo

TEMP_CONFIG_PATH = Path("/tmp/nixos")
TEMP_CONFIG_HOSTS_PATH = TEMP_CONFIG_PATH / "hosts"

TARGET_CONFIG_PATH = Path("/mnt/persist/etc/nixos")
PASSWORDS_PATH = Path("/mnt/persist/passwords")

NIX_WITH_FLAKES = ["nix", "--quiet", "--experimental-features", "nix-command flakes"]
DISKO_SOURCE = "github:nix-community/disko"

def install(config_url):
    info(f"Installing NixOS configuration from {config_url} ...")

    info(f"Cloning configuration into {TEMP_CONFIG_PATH} ...")
    shutil.rmtree(TEMP_CONFIG_PATH, ignore_errors=True)
    TEMP_CONFIG_PATH.mkdir(parents=True, exist_ok=True)
    Repo.clone_from(config_url, TEMP_CONFIG_PATH)

    prompt("select the host configuration you want to install")
    hosts = [host_dir.name for host_dir in TEMP_CONFIG_HOSTS_PATH.glob("*/")]
    host = hosts[select(hosts, deselected_prefix="  ", selected_prefix="> ")]
    print()

    prompt("select the main disk to install NixOS on")
    block_devices = get_block_devices()
    disk = block_devices[select(block_devices, deselected_prefix="  ", selected_prefix="> ")]
    warning(f"ALL DATA ON /dev/{disk} WILL BE ERASED.", prefix="WARNING: ")
    if not prompt_yes_or_no("continue?", deselected_prefix="  ", selected_prefix="> "):
        return
    print()

    info(f"Formatting /dev/{disk} with disko ...")
    disk_by_id = get_disk_by_id(disk)
    format_disk(host, disk_by_id)
    print()

    (TEMP_CONFIG_HOSTS_PATH / host / "device.nix").write_text(f"\"{disk_by_id}\"\n")
    (TEMP_CONFIG_HOSTS_PATH / host / "hostId.nix").write_text(f"\"{get_host_id(disk)}\"\n")
    (TARGET_CONFIG_PATH).mkdir(parents=True, exist_ok=True)
    for path in TEMP_CONFIG_PATH.glob("*"):
        shutil.move(path, TARGET_CONFIG_PATH)
    TEMP_CONFIG_PATH.rmdir()

    info("Installing NixOS from flake ...")
    install_nix_os(host)

    setup_user_passwords()

    success("Successfully installed NixOS!", prefix="")

def get_block_devices():
    return check_output("lsblk -I 8,259 -ndo NAME".split()).decode().strip().split()

def get_disk_by_id(disk):
    command = f"udevadm info -q symlink --name={disk}"
    disk_symlinks = sorted((
        symlink for symlink in check_output(command.split()).decode().strip().split()
        if symlink.startswith("disk/by-id/")
    ))
    return f"/dev/{disk_symlinks[0]}"

def format_disk(host, disk):
    disko_nix_path = TEMP_CONFIG_HOSTS_PATH / host / "disko.nix"
    command = NIX_WITH_FLAKES + (
        f"run {DISKO_SOURCE} -- --mode disko {disko_nix_path} --argstr device {disk}"
    ).split()
    check_call(command)

def get_host_id(disk):
    disk_serial_bytes = check_output(f"lsblk -ndo serial /dev/{disk}".split()).strip()
    return md5(disk_serial_bytes).hexdigest()[:8]

def install_nix_os(host):
    command = (
        f"nixos-install --root /mnt/ --flake path:{TARGET_CONFIG_PATH}#{host} --no-root-passwd"
    ).split()
    check_call(command)

def setup_user_passwords():
    PASSWORDS_PATH.mkdir(parents=True, exist_ok=True)
    users = [
        line.strip().split(":")[0]
        for line in Path("/mnt/etc/passwd").read_text().strip().split("\n")
        if not line.strip().endswith("/run/current-system/sw/bin/nologin")
    ]
    for user in users:
        while True:
            password = getpass(f"password for {user}: ")
            retyped = getpass(f"retype password for {user}: ")
            if password == retyped:
                break
            error("passwords do not match")
        hashed_password = check_output(("mkpasswd", password)).decode().strip()
        (PASSWORDS_PATH / user).write_text(hashed_password)
        print()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        error(f"python install.py <nixos-configuration-git-url>", prefix="")
        sys.exit(1)

    try:
        install(sys.argv[1])
    except KeyboardInterrupt:
        error("Aborting Execution! (KeyboardInterrupt)", prefix="")
