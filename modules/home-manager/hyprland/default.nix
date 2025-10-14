{nixosConfig, ...}: {
    imports = [
        ./hyprpaper.nix
        ./monitors.nix
        ./scratchpads.nix
        ./tofi.nix
        ./zoom.nix
    ];

    wayland.windowManager.hyprland = {
        enable = true;
        settings = {
            general = {
                layout = "master";

                gaps_in = 2;
                gaps_out = 4;

                border_size = 1;
                "col.active_border" = "rgba(A0A0A0E0)";
                "col.inactive_border" = "rgba(404040E0)";
                resize_on_border = true;
            };

            decoration = {
                rounding = 4;
            };

            xwayland.force_zero_scaling = true;

            input = with nixosConfig.services.xserver; {
                kb_model = xkb.model;
                kb_layout = xkb.layout;
                kb_variant = xkb.variant;
                kb_options = xkb.options;
                repeat_rate = 30;
                repeat_delay = 250;
                follow_mouse = 2;
                sensitivity = -0.1;
                accel_profile = "flat";
            };

            bind = [
                "SUPER, SUPER_L, exec, tofi-drun --drun-launch=true"

                "SUPER, left,  movewindow, l"
                "SUPER, right, movewindow, r"
                "SUPER, up,    movewindow, u"
                "SUPER, down,  movewindow, d"
                "SHIFT SUPER, left,  movefocus, l"
                "SHIFT SUPER, right, movefocus, r"
                "SHIFT SUPER, up,    movefocus, u"
                "SHIFT SUPER, down,  movefocus, d"

                "CTRL ALT, backspace, killactive"
                ", F11, fullscreen, 1"

                "CTRL ALT, left,  workspace, -1"
                "CTRL ALT, right, workspace, +1"
                "CTRL SUPER, left,  movetoworkspace, -1"
                "CTRL SUPER, right, movetoworkspace, +1"
            ];

            animations = {
                animation = [
                    "windows, 1, 3, default, slide"
                    "fade, 1, 5, default"
                    "border, 1, 5, default"
                    "workspaces, 1, 3, default"
                ];
            };

            master = {
                orientation = "left";
            };

            workspace = [
                "w[tv1]s[false], gapsout:0, gapsin:0"
                "f[1]s[false], gapsout:0, gapsin:0"
            ];

            windowrule = [
                "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
                "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
                "bordersize 0, floating:0, onworkspace:f[1]s[false]"
                "rounding 0, floating:0, onworkspace:f[1]s[false]"
            ];

            misc = {
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
            };
        };
    };
}
