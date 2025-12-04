{
    pkgs,
    panelHeight ? null,
}:
pkgs.gnome-shell.overrideAttrs (prevAttrs: {
    patches =
        (prevAttrs.patches or [])
        ++ [./panel-bottom.patch ./date-time-format.patch]
        ++ pkgs.lib.optionals (panelHeight != null) [
            (pkgs.replaceVars ./panel-height.patch {height = panelHeight;})
        ];
})
