finalPkgs: prevPkgs: {
    custom = rec {
        alejandra = finalPkgs.callPackage ./alejandra.nix {};
        configure = finalPkgs.callPackage ./configure.nix {};
        nix-output-monitor = import ./nix-output-monitor {pkgs = prevPkgs;};
        rebuild = finalPkgs.callPackage ./rebuild {inherit alejandra nix-output-monitor;};

        commit-time-to-author = finalPkgs.callPackage ./commit-time-to-author {};
        configure-codium = finalPkgs.callPackage ./configure-codium.nix {};
        fishPlugins.tide = import ./tide {pkgs = prevPkgs;};
        ibm-plex = import ./ibm-plex {pkgs = prevPkgs;};
        nerd-fonts.blex-mono = import ./ibm-plex/nerdfont.nix {pkgs = prevPkgs;};
        mkshell = finalPkgs.callPackage ./mkshell {};
        openpnp = finalPkgs.callPackage ./openpnp.nix {};
        sddm-theme = import ./sddm-theme {
            pkgs = prevPkgs;
            inherit wallpapers;
        };
        segoe-ui = finalPkgs.callPackage ./segoe-ui.nix {};
        uvtools = finalPkgs.callPackage ./uvtools {};
        wallpapers = import ./wallpapers.nix {pkgs = prevPkgs;};
    };
}
