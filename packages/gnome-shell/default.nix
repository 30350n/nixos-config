{pkgs}:
pkgs.gnome-shell.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./panel-bottom.patch ./date-time-format.patch];
})
