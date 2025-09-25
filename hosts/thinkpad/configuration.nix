{
    imports = [
        ./hardware-configuration.nix
        (import ./disko.nix {devices = import ./devices.nix;})

        ../../modules/nixos/base/configuration.nix
        ../../modules/nixos/bluetooth.nix
        ../../modules/nixos/gnome.nix
        ../../modules/nixos/sddm.nix
        ../../modules/nixos/ssh-server.nix
        ../../users/bobbe
    ];

    networking.hostId = import ./hostId.nix;

    home-manager = {
        users.bobbe = import ../../users/bobbe/home.nix;
        users.root = import ../../users/root/home.nix;
    };
}
