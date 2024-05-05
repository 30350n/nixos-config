{pkgs}:
pkgs.nix-output-monitor.overrideAttrs (finalAttrs: prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./silent.patch];
})
