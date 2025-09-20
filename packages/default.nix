{flake-inputs, ...}: {
    nixpkgs.overlays = [
        flake-inputs.nixos-core.overlays.default
        flake-inputs.nix-vscode-extensions.overlays.default
        (final: prev: {
            custom = rec {
                alejandra = final.callPackage ./alejandra.nix {};
                configure = final.callPackage ./configure.nix {};
                nix-output-monitor = import ./nix-output-monitor {pkgs = prev;};
                rebuild = final.callPackage ./rebuild {inherit alejandra nix-output-monitor;};

                commit-time-to-author = final.callPackage ./commit-time-to-author {};
                configure-codium = final.callPackage ./configure-codium.nix {};
                fishPlugins.tide = import ./tide {pkgs = prev;};
                ibm-plex = import ./ibm-plex {pkgs = prev;};
                nerd-fonts.blex-mono = import ./ibm-plex/nerdfont.nix {pkgs = prev;};
                mkshell = final.callPackage ./mkshell {};
                openpnp = final.callPackage ./openpnp.nix {};
                polkit = import ./polkit {pkgs = prev;};
                sddm-theme = import ./sddm-theme {
                    pkgs = prev;
                    inherit wallpapers;
                };
                segoe-ui = final.callPackage ./segoe-ui {};
                uvtools = final.callPackage ./uvtools {};
                wallpapers = import ./wallpapers.nix {
                    nix-wallpaper = flake-inputs.nix-wallpaper.packages.${final.system}.default;
                };
            };

            gnome-desktop = import ./gnome-desktop {pkgs = prev;};
            gnome-shell = import ./gnome-shell {pkgs = prev;};
        })
    ];
}
