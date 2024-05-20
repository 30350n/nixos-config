{hostName, ...}: {
    imports = [
        ../../common/base-configuration.nix
        ../../users/bobbe

        ./hardware-configuration.nix
        (import ./disko.nix {device = import ./device.nix;})
    ];

    networking = {
        inherit hostName;
        hostId = import ./hostId.nix;
    };
}
