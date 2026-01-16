{
    config,
    lib,
    pkgs,
    ...
} @ inputs: {
    imports = [./extensions];

    services.desktopManager.gnome.enable = true;
    services.gnome.core-apps.enable = false;

    environment.systemPackages =
        (with pkgs; [
            dconf-editor
            gnome-calculator
            gnome-console
            gnome-tweaks
            nautilus
        ])
        ++ (import ../../shared/gnome-shell-extensions.nix inputs).extensions;

    environment.gnome.excludePackages = with pkgs; [
        gnome-shell-extensions
        gnome-tour
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    nixpkgs.overlays = [
        (final: prev: {
            gnome-console = import ./gnome-console {pkgs = prev;};
            gnome-desktop = import ./gnome-desktop {pkgs = prev;};
            gnome-shell = import ./gnome-shell {
                pkgs = prev;
                panelHeight =
                    if !config.custom.isLaptop
                    then 40
                    else null;
            };
        })
    ];

    services.udev.packages = with pkgs; [
        gnome-settings-daemon
    ];

    security.wrappers.pkexec.source = lib.mkForce "${pkgs.custom.polkit.bin}/bin/pkexec";
}
