{
    lib,
    config,
    nixosConfig ? config,
    useExtensions ? false,
    wallpaper ? null,
    ...
} @ inputs:
lib.mkMerge [
    {
        "org/gnome/desktop/interface" = let
            font = builtins.elemAt nixosConfig.fonts.fontconfig.defaultFonts.sansSerif 0;
        in {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
            font-name = "${font} 12";
            show-battery-percentage = nixosConfig.custom.isLaptop;
        };

        "org/gnome/desktop/notifications".show-banners = false;

        "org/gnome/desktop/peripherals/touchpad" = {
            click-method = "areas";
            natural-scroll = false;
        };
        "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
            speed = -0.1;
        };

        "org/gnome/desktop/session".idle-delay = lib.gvariant.mkUint32 (
            if nixosConfig.custom.isLaptop
            then 15 * 60
            else 60 * 60
        );

        "org/gnome/settings-daemon/plugins/power" = {
            power-button-action = "interactive";
            sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
            sleep-inactive-battery-timeout = lib.gvariant.mkInt32 (
                if nixosConfig.custom.isLaptop
                then 60 * 60
                else 0
            );
        };

        "org/gnome/gnome-session".logout-prompt = false;

        "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
            night-light-temperature = lib.gvariant.mkUint32 3200;
        };

        "org/gnome/Console" = let
            font = builtins.elemAt nixosConfig.fonts.fontconfig.defaultFonts.monospace 0;
        in {
            use-system-font = false;
            custom-font = "${font} 12";
        };
    }
    (lib.mkIf useExtensions (import ./gnome-shell-extensions.nix inputs).dconf-settings)
    (lib.mkIf (wallpaper != null) {
        "org/gnome/desktop/background" = {
            picture-uri = wallpaper;
            picture-uri-dark = wallpaper;
        };
        "org/gnome/desktop/screensaver".picture-uri = wallpaper;
    })
]
