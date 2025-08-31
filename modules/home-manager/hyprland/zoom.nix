{pkgs, ...}: {
    wayland.windowManager.hyprland.settings = let
        script_name = "move-on-screen-displays";
        script_pkg = pkgs.writeShellApplication {
            name = script_name;
            runtimeInputs = [pkgs.jq];
            text = ''
                workspace=$(hyprctl activeworkspace -j | jq ".id")
                floating=$(hyprctl clients -j | jq ".[] | select(.floating)")
                zoom_windows=$(jq -r "select(.class == \"zoom\") | .address" <<< "$floating")

                for address in $zoom_windows; do
                    hyprctl dispatch movetoworkspacesilent "$workspace,address:$address"
                done
            '';
        };
    in {
        bind = [
            "CTRL ALT, left,  exec, ${script_pkg}/bin/${script_name}"
            "CTRL ALT, right, exec, ${script_pkg}/bin/${script_name}"
            "CTRL SUPER, left,  exec, ${script_pkg}/bin/${script_name}"
            "CTRL SUPER, right, exec, ${script_pkg}/bin/${script_name}"
        ];

        windowrulev2 = [
            "float, class:(^zoom$), initialTitle:(^(?!.*^zoom$).*$)"
        ];
    };
}
