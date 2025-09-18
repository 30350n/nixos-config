{pkgs, ...} @ inputs: {
    dconf = {
        enable = true;
        settings = let
            wallpaper = "${pkgs.custom.wallpapers."1080p"}/share/wallpapers/nixos-wallpaper.png";
        in
            import ../shared/dconf-settings.nix (inputs
            // {
                useExtensions = true;
                inherit wallpaper;
            });
    };

    gtk = {
        enable = true;

        theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
        };

        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme.override {
                color = "yellow";
            };
        };
    };

    qt = {
        enable = true;
        platformTheme.name = "adwaita-dark";
        style.name = "adwaita-dark";
    };
}
