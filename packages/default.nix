{pkgs ? import <nixpkgs> {}, ...}: {
    alejandra4 = pkgs.callPackage ./alejandra4.nix {};
    rebuild = pkgs.callPackage ./rebuild {};
    segoe-ui = pkgs.callPackage ./segoe-ui.nix {};
}
