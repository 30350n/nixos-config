{lib, ...}: {
    boot.initrd.postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zroot/root@blank
    '';

    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist" = {
        directories = [
            "/etc/nixos"
            "/etc/NetworkManager/system-connections"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/log"
        ];
        files = [
            "/etc/machine-id"
        ];
    };
}
