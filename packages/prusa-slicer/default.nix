{pkgs}:
pkgs.unstable.prusa-slicer.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./remove-printables-tab.patch];
})
