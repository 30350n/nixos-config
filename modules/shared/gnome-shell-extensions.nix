{
    lib,
    config,
    nixosConfig ? config,
    pkgs,
    ...
}: rec {
    extensions = with pkgs.gnomeExtensions; [
        appindicator
        ddterm
        just-perfection
        new-workspace-shortcut
        syncthing-indicator
        vscode-search-provider
        workspaces-indicator-by-open-apps
    ];

    dconf-settings = {
        "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = map (extension: extension.extensionUuid) extensions;
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
            background-opacity = 0.95;
            cursor-blink-mode = "off";
            hide-animation-duration = 0.1;
            show-animation-duration = 0.1;
            panel-icon-type = "none";
        };

        "org/gnome/shell/extensions/just-perfection" = {
            animation = 4;
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
            size-app-icon = 22;
            spacing-app-left = 3;
            spacing-app-right = 3;
            spacing-label-left = 3;
            spacing-label-right = 3;
        };
    };
}
