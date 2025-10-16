{
    config,
    lib,
    ...
}: {
    imports = (
        lib.filter
        (file: lib.strings.hasSuffix ".nix" file && file != ./default.nix)
        (lib.filesystem.listFilesRecursive ./.)
    );

    options.custom = let
        self = config.custom;
    in {
        isLaptop = lib.mkEnableOption "isLaptop";

        bluetooth = lib.mkEnableOption "bluetooth" // {default = self.isLaptop;};
        fish.enable = lib.mkEnableOption "fish" // {default = true;};
    };
}
