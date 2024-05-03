{
    imports = [
        ../../common/base-configuration.nix
        ../../common/users/bobbe.nix

        ./hardware-configuration.nix
        (import ./disko.nix {device = import ./device.nix;})
    ];

    networking = {
        hostName = "thinkpad";
        hostId = import ./hostId.nix;
    };
}
