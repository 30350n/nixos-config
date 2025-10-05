{
    imports = [
        ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos
        ../../users/max
    ];

    networking.hostId = import ./host-id.nix;

    custom.isLaptop = true;

    home-manager = {
        users.max = import ../../users/max/home.nix;
        users.root = import ../../users/root/home.nix;
    };
}
