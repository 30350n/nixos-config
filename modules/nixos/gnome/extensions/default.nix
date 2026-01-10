{
    nixpkgs.overlays = [
        (final: prev: {
            customGnomeExtensions = {
                multi-monitors-add-on = final.callPackage ./multi-monitors-add-on {};
            };
        })
    ];
}
