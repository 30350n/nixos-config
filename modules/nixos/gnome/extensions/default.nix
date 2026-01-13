{
    nixpkgs.overlays = [
        (final: prev: {
            customGnomeExtensions = {
                mic-indicator-visibility-manager =
                    final.callPackage ./mic-indicator-visibility-manager.nix {};
                multi-monitors-add-on = final.callPackage ./multi-monitors-add-on {};
            };
        })
    ];
}
