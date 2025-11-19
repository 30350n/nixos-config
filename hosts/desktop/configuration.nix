{
    imports = [
        ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos
        ../../users/max
    ];

    networking.hostId = import ./host-id.nix;

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

    custom.audio.defaultVolume = 0.5;
    custom.hyprland = {
        enable = true;
        monitors = ["DP-1,2560x1440@75,0x0,1" "HDMI-A-1,2560x1440@75,2560x0,1"];
    };
    custom.steam.enable = true;
    custom.wallpaper = {
        width = 2560;
        height = 1440;
    };
}
