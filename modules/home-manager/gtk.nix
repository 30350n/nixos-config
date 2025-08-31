{
    lib,
    nixosConfig,
    pkgs,
    ...
}: {
    dconf = {
        enable = true;
        settings = {
            "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                enable-hot-corners = false;
                show-battery-percentage = true;
            };
            "org/gnome/desktop/peripherals/touchpad" = {
                click-method = "areas";
                natural-scroll = false;
            };
            "org/gnome/gnome-session".logout-prompt = false;

            "org/gnome/settings-daemon/plugins/color" = {
                night-light-enabled = true;
                night-light-temperature = 3200;
            };

            "org/gnome/settings-daemon/plugins/power".power-button-action = "interactive";

            "org/gnome/shell" = {
                disable-user-extensions = false;
                enabled-extensions = with pkgs.gnomeExtensions; [
                    appindicator.extensionUuid
                    ddterm.extensionUuid
                    just-perfection.extensionUuid
                    new-workspace-shortcut.extensionUuid
                    syncthing-indicator.extensionUuid
                    workspaces-indicator-by-open-apps.extensionUuid
                ];
            };

            "com/github/amezin/ddterm" = {
                ddterm-toggle-hotkey = ["<Control><Alt>minus"];
                shortcut-focus-other-pane = ["<Alt>Left" "<Alt>Right"];
                hide-window-on-esc = true;

                use-system-font = false;
                custom-font = let
                    fonts = nixosConfig.fonts.fontconfig.defaultFonts.monospace;
                in "${lib.lists.last fonts} 12";

                window-position = "top";
                tab-position = "top";
                tab-show-shortcuts = false;
                tab-switcher-popup = false;
                background-opacity = 0.85;
                cursor-blink-mode = "off";
                hide-animation-duration = 0.1;
                show-animation-duration = 0.1;
                panel-icon-type = "none";
            };

            "org/gnome/shell/extensions/just-perfection" = {
                quick-settings-airplane-mode = false;
                quick-settings-dark-mode = false;
                startup-status = 0;
                support-notifier-type = 0;
                top-panel-position = 1;
                window-preview-caption = false;
                workspace-peek = true;
                workspace-popup = false;
                workspace-wrap-around = true;
            };

            "org/gnome/shell/extensions/newworkspaceshortcut" = {
                move-workspace-triggers-overview = false;
                workspace-left = ["<Shift><Alt>Left"];
                workspace-right = ["<Shift><Alt>Right"];
            };
            "org/gnome/desktop/wm/keybindings" = {
                close = ["<Alt>F4" "<Control><Alt>BackSpace"];
                move-to-workspace-left = ["<Control><Super>Left"];
                move-to-workspace-right = ["<Control><Super>Right"];
            };

            "org/gnome/shell/extensions/workspaces-indicator-by-open-apps" = {
                icons-ignored = ["com.github.amezin.ddterm"];
                indicator-hide-empty = true;
                indicator-round-borders = false;
                indicator-show-focused-app = false;
                size-app-icon = 22;
                spacing-app-left = 3;
                spacing-app-right = 3;
                spacing-label-left = 3;
                spacing-label-right = 3;
            };
        };
    };

    gtk = {
        enable = true;

        font = {
            name = builtins.elemAt nixosConfig.fonts.fontconfig.defaultFonts.sansSerif 0;
            size = 12;
        };

        theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
        };

        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme.override {
                color = "yellow";
            };
        };
    };

    qt = {
        enable = true;
        platformTheme.name = "adwaita-dark";
        style.name = "adwaita-dark";
    };
}
