{nixosConfig, ...}: {
    programs.alacritty = {
        enable = true;
        settings = {
            font = let
                font = builtins.elemAt nixosConfig.fonts.fontconfig.defaultFonts.monospace 0;
            in {
                normal.family = font;
                size = 12.5;
            };
            window.padding = {
                x = 8;
                y = 8;
            };
        };
    };
}
