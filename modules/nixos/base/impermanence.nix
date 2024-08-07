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
            "/root/.ssh"
            "/root/.cache/pre-commit"
            "/root/.config/VSCodium"
            "/root/.local/share/zoxide"
        ];
        files = [
            "/etc/machine-id"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
        ];
    };
}
