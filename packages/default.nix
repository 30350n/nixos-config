finalPkgs: prevPkgs: {
    custom = rec {
        alejandra = finalPkgs.callPackage ./alejandra.nix {};
        configure = finalPkgs.callPackage ./configure.nix {};
        nix-output-monitor = import ./nix-output-monitor {pkgs = prevPkgs;};
        rebuild = finalPkgs.callPackage ./rebuild {inherit alejandra nix-output-monitor;};

        commit-time-to-author = finalPkgs.callPackage ./commit-time-to-author {};
        configure-codium = finalPkgs.callPackage ./configure-codium.nix {};
        extra-desktop-items = finalPkgs.callPackage ./extra-desktop-items.nix {};
        fishPlugins.tide = finalPkgs.callPackage ./tide {pkgs = prevPkgs;};
        ibm-plex = finalPkgs.callPackage ./ibm-plex {pkgs = prevPkgs;};
        nerd-fonts.blex-mono = finalPkgs.callPackage ./ibm-plex/nerdfont.nix {pkgs = prevPkgs;};
        mate.mate-polkit = finalPkgs.callPackage ./mate-polkit {pkgs = prevPkgs;};
        mkshell = finalPkgs.callPackage ./mkshell {};
        nemo = finalPkgs.callPackage ./nemo {pkgs = prevPkgs;};
        openpnp = finalPkgs.callPackage ./openpnp.nix {};
        sddm-theme = finalPkgs.callPackage ./sddm-theme {
            pkgs = prevPkgs;
            inherit wallpapers;
        };
        segoe-ui = finalPkgs.callPackage ./segoe-ui.nix {};
        uvtools = finalPkgs.callPackage ./uvtools {};
        wallpapers = finalPkgs.callPackage ./wallpapers {};
    };
}
