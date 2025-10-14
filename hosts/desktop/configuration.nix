{
    imports = [
        ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos
        ../../users/max
    ];

    networking.hostId = import ./host-id.nix;

    custom.audio.defaultVolume = 0.5;
    custom.hyprland = {
        enable = true;
        monitors = ["DP-1,2560x1440@75,0x0,1" "HDMI-A-1,2560x1440@75,2560x0,1"];
    };
    custom.nvidia.enable = true;
    custom.steam.enable = true;
    custom.wallpaper = {
        width = 2560;
        height = 1440;
    };

    home-manager = {
        users.max = import ../../users/max/home.nix;
        users.root = import ../../users/root/home.nix;
    };
}
