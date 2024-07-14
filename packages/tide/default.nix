{pkgs}:
pkgs.fishPlugins.tide.overrideAttrs (
    prevAttrs: {
        src = pkgs.fetchFromGitHub {
            owner = "chapa";
            repo = "tide";
            rev = "8faea68e01dd4cee5e60e5875af772ec5b7db1af";
            hash = "sha256-uFTXCQEfsYCIooNSSDhuxZY7PAn3Ldt/WN0CqKFr2ys=";
        };
        patches = (prevAttrs.patches or []) ++ [./icon-after-status.patch];
    }
)
