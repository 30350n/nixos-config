{
    hostName,
    pkgs,
    ...
}: {
    services.hyprpaper = let
        wallpaperDirectory = "${pkgs.custom.wallpapers}/share/backgrounds";
        wallpaper_1080p = "${wallpaperDirectory}/debashis_kolkata_1920x1080.png";
    in {
        enable = true;
        settings =
            {
                splash = false;
                ipc = "off";
            }
            // (
                if hostName == "thinkpad"
                then {
                    preload = wallpaper_1080p;
                    wallpaper = "eDP-1, ${wallpaper_1080p}";
                }
                else {}
            );
    };
}
