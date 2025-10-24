{pkgs}:
pkgs.gnome-desktop.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./date-time-format.patch];
})
