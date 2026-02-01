{
    name,
    vmConfig,
    cpuVendor,
    cpuSupportedFlags,
    #
    fetchFromGitHub,
    lib,
    stdenvNoCC,
    qemu,
    OVMF,
    OVMFFull,
}:
stdenvNoCC.mkDerivation {
    name = "quickemu-args-${name}";
    version = "4.9.9pre";

    src = fetchFromGitHub {
        owner = "quickemu-project";
        repo = "quickemu";
        rev = "879d0ba885908ac66ffa25c8a7892b3a113a13b9";
        sha256 = "ofsebZx+U/QNcRY1mCk5m9qmHlCzxN4T4xkabYzLqeU=";
    };

    patches = [./quickemu-args.patch];

    OS_KERNEL = "Linux";
    ARCH_HOST = stdenvNoCC.hostPlatform.parsed.cpu.name;
    VMNAME = name;
    VMDIR = vmConfig.directory;
    DISK_IMG = vmConfig.disk;
    DISK_FORMAT = vmConfig.diskFormat;
    GUEST_OS = vmConfig.guestOs;
    CPU_CORES = vmConfig.cpuCores * 2;
    HOST_CPU_SMT = "on";
    HOST_CPU_SOCKETS = 1;
    HOST_CPU_VENDOR =
        if cpuVendor == "amd"
        then "AuthenticAMD"
        else if cpuVendor == "intel"
        then "GenuineIntel"
        else assert false; null;
    HOST_CPU_SUPPORTED_FLAGS = "Flags: ${lib.concatStringsSep " " cpuSupportedFlags}";
    RAM_VM = vmConfig.ram;
    SECURE_BOOT =
        if vmConfig.secureBoot
        then "on"
        else "off";
    DISPLAY =
        if vmConfig.viewer == "remote-viewer"
        then "spice"
        else if vmConfig.viewer == "looking-glass"
        then "none"
        else assert false; null;
    ACCESS = "local";
    SSH_PORT = vmConfig.sshPort;
    SERIAL =
        if vmConfig.guestOs == "windows"
        then "none"
        else "socket";
    SOUND_CARD = "usb-audio";
    USB_CONTROLLER = "xhci";

    QEMU_VER_SHORT = "${lib.versions.major qemu.version}${lib.versions.minor qemu.version}";

    EFI_CODE =
        if vmConfig.secureBoot
        then OVMFFull.firmware
        else OVMF.firmware;
    EFI_VARS = "${vmConfig.directory}/OVMF_VARS.fd";
    passthru.efi-vars =
        if vmConfig.secureBoot
        then OVMFFull.variables
        else OVMF.variables;

    installPhase = ''
        bash quickemu
    '';
}
