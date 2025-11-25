{lib, ...}: {
    boot.initrd.postMountCommands = lib.mkAfter ''
        echo "running boot.initrd.postMountCommands" > /dev/kmsg
        zfs rollback -r zroot/root@blank > /dev/kmsg 2>&1
    '';

    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist" = {
        directories = [
            "/etc/nixos"
            "/etc/NetworkManager/system-connections"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/lib/systemd/timers"
            "/var/log"
            "/root/.ssh"
            "/root/.cache/pre-commit"
            "/root/.config/VSCodium"
            "/root/.local/share/fish"
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
