{pkgs, ...}: {
    services.xserver.desktopManager.gnome.enable = true;
    services.gnome.core-apps.enable = false;
    environment.systemPackages =
        (with pkgs; [
            baobab
            eyedropper
            gnome-calculator
            gnome-tweaks
            nautilus
            simple-scan
        ])
        ++ (with pkgs.gnomeExtensions; [
            appindicator
            ddterm
            just-perfection
            new-workspace-shortcut
            syncthing-indicator
            vscode-search-provider
            workspaces-indicator-by-open-apps
        ]);
    environment.gnome.excludePackages = with pkgs; [
        gnome-shell-extensions
        gnome-tour
    ];
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.udev.packages = with pkgs; [
        gnome-settings-daemon
    ];
}
