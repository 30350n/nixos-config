{
    lib,
    nixosConfig,
    pkgs,
    ...
}: {
    dconf = {
        enable = true;
        settings = {
            "org/gnome/shell" = {
                disable-user-extensions = false;
                enabled-extensions = with pkgs.gnomeExtensions; [
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

            "org/gnome/desktop/interface".color-scheme = "prefer-dark";
            "org/gnome/gnome-session".logout-prompt = false;
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
