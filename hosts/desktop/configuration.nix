{
    imports = [
        ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos
        ../../users/max
    ];

    networking.hostId = import ./host-id.nix;

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
