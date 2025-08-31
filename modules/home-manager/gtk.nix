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
            "org/gnome/desktop/peripherals/touchpad".natural-scroll = false;
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
                    new-workspace-shortcut.extensionUuid
                    syncthing-indicator.extensionUuid
                    workspaces-indicator-by-open-apps.extensionUuid
                ];
            };

            "org/gnome/shell/extensions/newworkspaceshortcut" = {
                move-workspace-triggers-overview = false;
                workspace-left = ["<Shift><Alt>Left"];
                workspace-right = ["<Shift><Alt>Right"];
            };
            "org/gnome/desktop/wm/keybindings" = {
                move-to-workspace-left = ["<Control><Super>Left"];
                move-to-workspace-right = ["<Control><Super>Right"];
            };

            "org/gnome/shell/extensions/workspaces-indicator-by-open-apps" = {
                indicator-hide-empty = true;
                indicator-round-borders = false;
                indicator-show-focused-app = false;
                size-app-icon = 22;
                spacing-app-left = 3;
                spacing-app-right = 3;
                spacing-label-left = 3;
                spacing-label-right = 3;
            };

            "org/gnome/Console" = let
                fonts = nixosConfig.fonts.fontconfig.defaultFonts.monospace;
            in {
                "custom-font" = "${builtins.elemAt fonts (builtins.length fonts - 1)} 12";
                "use-system-font" = false;
            };
        };
    };

    gtk = {
        enable = true;

        font = let
            fonts = nixosConfig.fonts.fontconfig.defaultFonts.sansSerif;
        in {
            name = lib.lists.findFirst (_: true) "" fonts;
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
