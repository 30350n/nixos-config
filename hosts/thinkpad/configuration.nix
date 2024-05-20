{hostName, ...}: {
    imports = [
        ./hardware-configuration.nix
        (import ./disko.nix {device = import ./device.nix;})

        ../../modules/nixos/base/configuration.nix
        ../../modules/nixos/bluetooth.nix
        ../../modules/nixos/hyprland.nix
        ../../users/bobbe
    ];

    networking = {
        inherit hostName;
        hostId = import ./hostId.nix;
    };
}
