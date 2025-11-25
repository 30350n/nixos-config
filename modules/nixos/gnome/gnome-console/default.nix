{pkgs}:
pkgs.gnome-console.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./disable-close-prompt.patch];
})
