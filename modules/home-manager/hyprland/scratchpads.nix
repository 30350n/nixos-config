{
    wayland.windowManager.hyprland = let
        workspace_name = name: "special:scratchpad_${name}";
        rules = name:
            "[workspace ${workspace_name name} silent; float; noanim; dimaround; stayfocused; "
            + "bordercolor rgb(606060); rounding 8; opacity 0.9; size 60% 80%]";
        scratchpad_cmd = name: cmd: "${rules name} ${cmd}; hyprctl dispatch submap reset";
    in {
        settings = {
            workspace = let
                on_created_empty = name: "${workspace_name name}, on-created-empty:";
            in [
                ((on_created_empty "terminal") + (scratchpad_cmd "terminal" "alacritty"))
                ((on_created_empty "python") + (scratchpad_cmd "python" "alacritty -e python"))
            ];

            animations.animation = [
                "specialWorkspace, 1, 3, default, slidevert"
            ];
        };

        extraConfig = ''
            bind=CTRL ALT, T, togglespecialworkspace, scratchpad_terminal
            bind=CTRL ALT, T, submap, scratchpad_terminal
            submap=scratchpad_terminal
            bind=CTRL ALT, T, togglespecialworkspace, scratchpad_terminal
            bind=CTRL ALT, T, submap, reset
            bind=, escape, togglespecialworkspace, scratchpad_terminal
            bind=, escape, submap, reset
            submap=reset

            bind=CTRL ALT, P, togglespecialworkspace, scratchpad_python
            bind=CTRL ALT, P, submap, scratchpad_python
            submap=scratchpad_python
            bind=CTRL ALT, P, togglespecialworkspace, scratchpad_python
            bind=CTRL ALT, P, submap, reset
            bind=, escape, togglespecialworkspace, scratchpad_python
            bind=, escape, submap, reset
            submap=reset
        '';
    };
}
