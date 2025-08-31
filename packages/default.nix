{flake-inputs, ...}: {
    nixpkgs.overlays = [
        flake-inputs.nixos-core.overlays.default
        flake-inputs.nix-vscode-extensions.overlays.default
        (final: prev: {
            custom = {
                commit-time-to-author = final.callPackage ./commit-time-to-author {};
                configure-codium = final.callPackage ./configure-codium.nix {};
                extra-desktop-items = final.callPackage ./extra-desktop-items.nix {};
                ibm-plex = import ./ibm-plex {pkgs = prev;};
                nerd-fonts.blex-mono = import ./ibm-plex/nerdfont.nix {pkgs = prev;};
                mkshell = final.callPackage ./mkshell {};
                openpnp = final.callPackage ./openpnp.nix {};
                polkit = import ./polkit {pkgs = prev;};
                segoe-ui = final.callPackage ./segoe-ui {};
                uvtools = final.callPackage ./uvtools {};
            };

            gnome-desktop = import ./gnome-desktop {pkgs = prev;};
            gnome-shell = import ./gnome-shell {pkgs = prev;};
        })
    ];
}
