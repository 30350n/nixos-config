{
    imports = [
        ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos
        ../../users/bobbe
    ];

    networking.hostId = import ./host-id.nix;

    home-manager = {
        users.bobbe = import ../../users/bobbe/home.nix;
        users.root = import ../../users/root/home.nix;
    };
}
