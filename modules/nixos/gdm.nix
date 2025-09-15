{
    services.xserver.displayManager.gdm.enable = true;

    nixpkgs.overlays = [
        (finalPkgs: prevPkgs: {
            gnome-shell = import ../../packages/gnome-shell {pkgs = prevPkgs;};
        })
    ];
}
