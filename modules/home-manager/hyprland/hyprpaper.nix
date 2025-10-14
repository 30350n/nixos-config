{nixosConfig, ...}: {
    services.hyprpaper = let
        wallpaper = nixosConfig.custom.wallpaper.file;
    in {
        enable = true;
        settings = {
            splash = false;
            ipc = "off";

            preload = wallpaper;
            wallpaper = "eDP-1, ${wallpaper}";
        };
    };
}
