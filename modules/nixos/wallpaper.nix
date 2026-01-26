{
    config,
    flake-inputs,
    lib,
    pkgs,
    ...
}: {
    options.custom.wallpaper = {
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
        file = lib.mkOption {
            type = lib.types.str;
            internal = true;
            readOnly = true;
            default = let
                system = pkgs.stdenv.hostPlatform.system;
                package = flake-inputs.nix-wallpaper.packages.${system}.default.override {
                    preset = "gruvbox-dark-rainbow";
                    inherit (config.custom.wallpaper) logoSize width height;
                };
            in "${package}/share/wallpapers/nixos-wallpaper.png";
        };
    };
}
