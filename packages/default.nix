{
    config,
    flake-inputs,
    ...
}: {
    nixpkgs.overlays = [
        flake-inputs.nixos-core.overlays.default
        flake-inputs.nix-vscode-extensions.overlays.default
        (final: prev: {
            custom = let
                wrapWine = final.callPackage ./wrapWine.nix {};
            in {
                ableton-live = final.callPackage ./ableton-live {inherit wrapWine;};
                commit-time-to-author = final.callPackage ./commit-time-to-author {};
                configure-codium = final.callPackage ./configure-codium.nix {};
                extra-desktop-items = final.callPackage ./extra-desktop-items.nix {};
                ibm-plex = import ./ibm-plex {pkgs = prev;};
                native-access = final.callPackage ./native-access {inherit wrapWine;};
                nerd-fonts.blex-mono = import ./ibm-plex/nerdfont.nix {pkgs = prev;};
                mate.mate-polkit = import ./mate-polkit {pkgs = prev;};
                mkshell = final.callPackage ./mkshell {};
                openpnp = final.callPackage ./openpnp.nix {};
                polkit = import ./polkit {pkgs = prev;};
                segoe-ui = final.callPackage ./segoe-ui {};
                uvtools = final.callPackage ./uvtools {};
                yt-dlp-music = final.callPackage ./yt-dlp-music {};
            };

            fish = import ./fish.nix {pkgs = prev;};

            gnome-desktop = import ./gnome-desktop {pkgs = prev;};
            gnome-shell = import ./gnome-shell {
                pkgs = prev;
                panelHeight =
                    if config.custom.isLaptop
                    then 40
                    else null;
            };
        })
    ];
}
