{
    nixosConfig,
    pkgs,
    ...
} @ inputs: {
    dconf = {
        enable = true;
        settings = import ../shared/dconf-settings.nix (inputs
        // {
            useExtensions = true;
            wallpaper = nixosConfig.custom.wallpaper.file;
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
