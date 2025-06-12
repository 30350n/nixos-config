finalPkgs: prevPkgs: {
    custom = rec {
        alejandra = finalPkgs.callPackage ./alejandra.nix {};
        configure = finalPkgs.callPackage ./configure.nix {};
        nix-output-monitor = import ./nix-output-monitor {pkgs = prevPkgs;};
        rebuild = finalPkgs.callPackage ./rebuild {
            alejandra = alejandra;
            nix-output-monitor = nix-output-monitor;
        };

        nemo = finalPkgs.callPackage ./nemo {pkgs = prevPkgs;};
        configure-codium = finalPkgs.callPackage ./configure-codium.nix {};
        extra-desktop-items = finalPkgs.callPackage ./extra-desktop-items.nix {};
        fishPlugins.tide = finalPkgs.callPackage ./tide {pkgs = prevPkgs;};
        ibm-plex = finalPkgs.callPackage ./ibm-plex {pkgs = prevPkgs;};
        mate.mate-polkit = finalPkgs.callPackage ./mate-polkit {pkgs = prevPkgs;};
        mkshell = finalPkgs.callPackage ./mkshell {};
        openpnp = finalPkgs.callPackage ./openpnp.nix {};
        sddm-theme = finalPkgs.callPackage ./sddm-theme {
            pkgs = prevPkgs;
            wallpapers = wallpapers;
        };
        segoe-ui = finalPkgs.callPackage ./segoe-ui.nix {};
        wallpapers = finalPkgs.callPackage ./wallpapers {};
    };
}
