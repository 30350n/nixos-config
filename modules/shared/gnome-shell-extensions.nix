{
    lib,
    config,
    nixosConfig ? config,
    pkgs,
    ...
}: rec {
    extensions = with pkgs.gnomeExtensions; [
        alphabetical-app-grid
        appindicator
        ddterm
        gamemode-shell-extension
        just-perfection
        pkgs.custom.gnomeExtensions.multi-monitors-add-on
        new-workspace-shortcut
        syncthing-indicator
        unblank
        vscode-search-provider
        workspaces-indicator-by-open-apps
    ];

    dconf-settings = let
        panel =
            if nixosConfig.custom.isLaptop
            then {
                icon-size = 16;
                workspace-spacing = 3;
                workspace-labels = 12;
            }
            else {
                icon-size = 20;
                workspace-spacing = 4;
                workspace-labels = 14;
            };
    in {
        "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = map (extension: extension.extensionUuid) extensions;
        };

        "com/github/amezin/ddterm" = let
            font = builtins.elemAt nixosConfig.fonts.fontconfig.defaultFonts.monospace 0;
        in {
            ddterm-toggle-hotkey = ["<Control><Alt>minus"];
            shortcut-focus-other-pane = ["<Alt>Left" "<Alt>Right"];
            hide-window-on-esc = true;

            use-system-font = false;
            custom-font = "${font} 12";

            window-position = "top";
            tab-position = "top";
            tab-show-shortcuts = false;
            tab-switcher-popup = false;
            background-opacity = 0.95;
            cursor-blink-mode = "off";
            hide-animation-duration = 0.1;
            show-animation-duration = 0.1;
            panel-icon-type = "none";
        };

        "org/gnome/shell/extensions/appindicator" = {
            icon-size = panel.icon-size + 2;
        };

        "org/gnome/shell/extensions/gamemodeshellextension" = {
            show-icon-only-when-active = true;
            show-launch-notification = false;
        };

        "org/gnome/shell/extensions/just-perfection" = {
            animation = 4;
            panel-button-padding-size = 8;
            panel-icon-size = panel.icon-size;
            panel-indicator-padding-size = 6;
            panel-notification-icon = false;
            quick-settings-airplane-mode = false;
            quick-settings-dark-mode = false;
            startup-status = 0;
            support-notifier-type = 0;
            window-demands-attention-focus = true;
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
            size-app-icon = panel.icon-size + 6;
            size-labels = panel.workspace-labels;
            spacing-app-left = panel.workspace-spacing;
            spacing-app-right = panel.workspace-spacing;
            spacing-label-left = panel.workspace-spacing;
            spacing-label-right = panel.workspace-spacing;
        };
    };
}
