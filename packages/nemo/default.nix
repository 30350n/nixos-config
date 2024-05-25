{pkgs}:
pkgs.cinnamon.nemo.overrideAttrs (prevAttrs: {
    patches =
        (prevAttrs.patches or [])
        ++ [
            ./desktop-entry.patch
            ./icon-size.patch
            ./monospace-list-view.patch
        ];
})
