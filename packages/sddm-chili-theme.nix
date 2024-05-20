{
    pkgs,
    wallpapers,
}:
pkgs.sddm-chili-theme.override {
    themeConfig = {
        background = "${wallpapers}/share/backgrounds/debashis_kolkata_1920x1080.png";
        ScreenWidth = 1920;
        ScreenHeight = 1080;
    };
}
