{
    pkgs,
    panelHeight ? null,
}:
pkgs.gnome-shell.overrideAttrs (prevAttrs: {
    patches =
        (prevAttrs.patches or [])
        ++ [./panel-bottom.patch ./date-time-format.patch]
        ++ (
            if panelHeight
            then [(pkgs.replaceVars ./panel-height.patch {height = panelHeight;})]
            else []
        );
})
