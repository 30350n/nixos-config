final_pkgs: prev_pkgs: {
    custom = rec {
        alejandra4 = final_pkgs.callPackage ./alejandra4.nix {};
        configure = final_pkgs.callPackage ./configure.nix {};
        rebuild = final_pkgs.callPackage ./rebuild {alejandra4 = alejandra4;};
        segoe-ui = final_pkgs.callPackage ./segoe-ui.nix {};
    };
}
