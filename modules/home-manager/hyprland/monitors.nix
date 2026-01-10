{
    lib,
    nixosConfig,
    ...
}: {
    wayland.windowManager.hyprland.settings = let
        monitors = nixosConfig.custom.hyprland.monitors;
    in {
        monitor =
            if monitors == []
            then [",highres,auto,1"]
            else monitors;

        workspace =
            lib.lists.imap1 (i: monitor: "${toString i},monitor:${monitor}")
            (map (str: builtins.head (lib.strings.split "," str)) (lib.lists.dropEnd 1 monitors));
    };
}
