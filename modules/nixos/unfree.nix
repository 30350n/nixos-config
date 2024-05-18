{
    nixpkgs.overlays = let
        getUnfreePackages = pkgs: lib:
            lib.attrsets.filterAttrs (
                name: pkg: (builtins.tryEval pkg.meta.unfree or true).value
            )
            pkgs;
        makeUnfreePackages = pkgs: lib:
            builtins.mapAttrs (
                name: pkg:
                    if builtins.hasAttr "meta" pkg
                    then pkg.overrideAttrs (final: prev: {meta.allowUnfree = true;})
                    else makeUnfreePackages (getUnfreePackages pkg lib) lib
            )
            pkgs;
    in [
        (final: prev: {
            unfree = makeUnfreePackages (getUnfreePackages prev prev.lib) prev.lib;
        })
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
        (builtins.tryEval pkg.meta.allowUnfree or false).value;
}
