{
    config,
    flake-inputs,
    lib,
    pkgs,
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
        steam.enable = lib.mkEnableOption "steam";
        wallpaper = {
            width = lib.mkOption {
                type = lib.types.int;
                default = 1920;
            };
            height = lib.mkOption {
                type = lib.types.int;
                default = 1080;
            };
            logoSize = lib.mkOption {
                type = lib.types.float;
                default = 10.0;
            };
            file = let
                package = flake-inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
                    preset = "gruvbox-dark-rainbow";
                    inherit (self.wallpaper) logoSize;
                    inherit (self.wallpaper) width;
                    inherit (self.wallpaper) height;
                };
            in
                lib.mkOption {
                    type = lib.types.string;
                    default = "${package}/share/wallpapers/nixos-wallpaper.png";
                };
        };
    };
}
