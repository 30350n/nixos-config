finalPkgs: prevPkgs: {
    custom = rec {
        alejandra4 = finalPkgs.callPackage ./alejandra4.nix {};
        nix-output-monitor-silent = import ./nix-output-monitor-silent {pkgs = prevPkgs;};
        configure = finalPkgs.callPackage ./configure.nix {};
        rebuild = finalPkgs.callPackage ./rebuild {
            alejandra = alejandra4;
            nix-output-monitor = nix-output-monitor-silent;
        };

        ibm-plex = finalPkgs.callPackage ./ibm-plex {pkgs = prevPkgs;};
        segoe-ui = finalPkgs.callPackage ./segoe-ui.nix {};
        wallpapers = finalPkgs.callPackage ./wallpapers {};
    };
}
