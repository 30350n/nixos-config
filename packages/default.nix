finalPkgs: prevPkgs: {
    custom = rec {
        alejandra4 = finalPkgs.callPackage ./alejandra4.nix {};
        configure = finalPkgs.callPackage ./configure.nix {};
        configure-codium = finalPkgs.callPackage ./configure-codium.nix {};
        extra-desktop-items = finalPkgs.callPackage ./extra-desktop-items.nix {};
        nix-output-monitor-silent = import ./nix-output-monitor-silent {pkgs = prevPkgs;};
        rebuild = finalPkgs.callPackage ./rebuild {
            alejandra = alejandra4;
            nix-output-monitor = nix-output-monitor-silent;
        };

        ibm-plex = finalPkgs.callPackage ./ibm-plex {pkgs = prevPkgs;};
        openpnp = finalPkgs.callPackage ./openpnp.nix {};
        sddm-chili-theme = finalPkgs.callPackage ./sddm-chili-theme.nix {
            pkgs = prevPkgs;
            wallpapers = wallpapers;
        };
        segoe-ui = finalPkgs.callPackage ./segoe-ui.nix {};
        wallpapers = finalPkgs.callPackage ./wallpapers {};

        fishPlugins.tide = finalPkgs.callPackage ./tide {pkgs = prevPkgs;};
    };
}
