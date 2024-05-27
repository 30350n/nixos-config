{pkgs}:
pkgs.mate.mate-polkit.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./clean_dialog.patch];
})
