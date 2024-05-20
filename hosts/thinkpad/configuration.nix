{hostName, ...}: {
    imports = [
        ./hardware-configuration.nix
        (import ./disko.nix {device = import ./device.nix;})

        ../../modules/nixos/base/configuration.nix
        ../../users/bobbe
    ];

    networking = {
        inherit hostName;
        hostId = import ./hostId.nix;
    };
}
