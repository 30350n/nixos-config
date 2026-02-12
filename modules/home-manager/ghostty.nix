{nixosConfig, ...}: {
    programs.ghostty = {
        enable = true;
        settings = {
            theme = "Gruvbox Dark Hard";
            font-family = builtins.elemAt nixosConfig.fonts.fontconfig.defaultFonts.monospace 0;
            font-size = 12.5;
            window-padding-x = 5;
            window-padding-y = 5;
        };
    };
}
