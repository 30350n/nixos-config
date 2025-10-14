{
    lib,
    nixosConfig,
    ...
}: {
    wayland.windowManager.hyprland.settings = {
        monitor =
            if nixosConfig.custom.hyprland.monitors == []
            then ",highres,auto,1"
            else nixosConfig.custom.hyprland.monitors;

        workspace = let
            monitors =
                map (monitor: builtins.head (lib.strings.split "," monitor))
                nixosConfig.custom.hyprland.monitors;
        in
            map (i: "${builtins.toString (i + 1)},monitor:${builtins.elemAt monitors i}")
            (builtins.genList (i: i) (builtins.length monitors - 1));
    };
}
