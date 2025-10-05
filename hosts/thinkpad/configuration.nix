{
    imports = [
        ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos/base/configuration.nix
        ../../modules/nixos/bluetooth.nix
        ../../modules/nixos/gdm.nix
        ../../modules/nixos/gnome.nix
        ../../modules/nixos/ssh-server.nix
        ../../users/bobbe
    ];

    networking.hostId = import ./host-id.nix;

    home-manager = {
        users.bobbe = import ../../users/bobbe/home.nix;
        users.root = import ../../users/root/home.nix;
    };
}
