{pkgs}:
pkgs.nix-output-monitor.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./silent.patch];
})
