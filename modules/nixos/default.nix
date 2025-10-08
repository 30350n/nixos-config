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

        audio = {
            enable = lib.mkEnableOption "audio" // {default = true;};
            realtime = lib.mkEnableOption "realtime" // {default = true;};
        };
        bluetooth = lib.mkEnableOption "bluetooth" // {default = self.isLaptop;};
        boot.silent = lib.mkEnableOption "silentboot" // {default = true;};
        fish.enable = lib.mkEnableOption "fish" // {default = true;};
        nvidia.enable = lib.mkEnableOption "nvidia";
    };
}
