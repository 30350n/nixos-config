{
    config,
    hostName,
    lib,
    ...
}: {
    imports = (
        lib.filter
        (file: lib.strings.hasSuffix ".nix" file && file != ./default.nix)
        (lib.filesystem.listFilesRecursive ./.)
    );

    options.custom = {
        isLaptop = lib.mkEnableOption "isLaptop";

        fish.enable = lib.mkEnableOption "fish" // {default = true;};
    };

    config = {
        hardware.bluetooth.enable = lib.mkOverride 999 config.custom.isLaptop;

        networking = {
            networkmanager.enable = true;
            inherit hostName;
            enableIPv6 = false;
        };

        services = {
            openssh.enable = true;
            printing.enable = true;
        };

        users.mutableUsers = false;
        users.users.root.hashedPasswordFile = "/persist/passwords/root";

        system.stateVersion = "23.11";
    };
}
