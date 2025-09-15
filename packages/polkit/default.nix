{pkgs}:
pkgs.polkit.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or []) ++ [./pkexec-better-cmdline-short.patch];
})
