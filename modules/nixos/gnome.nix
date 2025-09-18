{
    lib,
    pkgs,
    ...
} @ inputs: {
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
        ++ (import ../shared/gnome-shell-extensions.nix inputs).extensions;
    environment.gnome.excludePackages = with pkgs; [
        gnome-shell-extensions
        gnome-tour
    ];
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.udev.packages = with pkgs; [
        gnome-settings-daemon
    ];

    security.wrappers.pkexec.source = lib.mkForce "${pkgs.custom.polkit.bin}/bin/pkexec";
}
