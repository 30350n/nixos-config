{
    imports = [
        ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos
        ../../users/max
    ];

    networking.hostId = import ./host-id.nix;

    nixos-core.impermanence = {
        enable = true;
        persistFileSystem = "/persist";
        resetCommands = "zfs rollback -r zroot/root@blank";
    };

    services.zfs.autoScrub.enable = true;

    boot.loader.systemd-boot.windows = {
        "10" = {
            efiDeviceHandle = "HD2c";
            sortKey = "z_windows";
        };
    };

    services.displayManager.autoLogin = {
        enable = true;
        user = "max";
    };

    custom = {
        audio = {
            devices = {
                disabled = ["!~.*usb-BEHRINGER_UMC1820.*"];
                umc1820.serial = "0E063B4D";
            };
            defaultVolume = 0.6;
        };
        hyprland = {
            enable = true;
            monitors = ["DP-2,2560x1440@75,0x0,1" "HDMI-A-1,2560x1440@75,2560x0,1"];
        };
        steam.enable = true;
        wallpaper = {
            width = 2560;
            height = 1440;
        };
    };
}
