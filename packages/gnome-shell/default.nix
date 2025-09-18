{pkgs}:
pkgs.gnome-shell.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./bottom-bar.patch ./date-time-format.patch];
})
