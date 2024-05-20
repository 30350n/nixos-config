{
    lib,
    nixosConfig,
    ...
}: {
    programs.alacritty = {
        enable = true;
        settings = {
            font = let
                fonts = nixosConfig.fonts.fontconfig.defaultFonts.monospace;
            in {
                normal.family = lib.lists.findFirst (_: true) "" fonts;
                size = 12.5;
            };
            window.padding = {
                x = 8;
                y = 8;
            };
        };
    };
}
