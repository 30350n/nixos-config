{nix-wallpaper}: let
    preset = "gruvbox-dark-rainbow";
    logoSize = 10;
in {
    "1080p" = nix-wallpaper.override {
        inherit preset logoSize;
        width = 1920;
        height = 1080;
    };
    "1440p" = nix-wallpaper.override {
        inherit preset logoSize;
        width = 2160;
        height = 1440;
    };
}
