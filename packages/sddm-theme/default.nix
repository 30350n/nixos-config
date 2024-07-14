{
    pkgs,
    wallpapers,
}: (
    (pkgs.sddm-chili-theme.override {
        themeConfig = {
            background = "${wallpapers}/share/backgrounds/debashis_kolkata_1920x1080.png";
            ScreenWidth = 1920;
            ScreenHeight = 1080;
        };
    })
    .overrideAttrs (prevAttrs: {
        pname = "sddm-theme";

        prePatch = ''
            cp ${./icons/reboot.svg} assets/reboot.svg
            cp ${./icons/shutdown.svg} assets/shutdown.svg
            cp ${./icons/suspend.svg} assets/suspend.svg
        '';

        patches = [
            ./icons.patch
            ./no-login-button.patch
            ./time-format.patch
        ];
    })
)
