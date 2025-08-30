{hostName, ...}: {
    imports = [
        ./hardware-configuration.nix
        (import ./disko.nix {device = import ./device.nix;})

        ../../modules/nixos/base/configuration.nix
        ../../modules/nixos/bluetooth.nix
        ../../modules/nixos/gnome.nix
        ../../modules/nixos/sddm.nix
        ../../modules/nixos/ssh-server.nix
        ../../users/bobbe
    ];

    networking = {
        inherit hostName;
        hostId = import ./hostId.nix;
    };
}
