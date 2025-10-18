{
    imports = [
        ./hardware-configuration.nix
        ./disko.nix

        ../../modules/nixos
        ../../users/max
    ];

    networking.hostId = import ./host-id.nix;

    custom.isLaptop = true;
}
