{config, ...}: {
    xdg.userDirs = let
        home = config.home.homeDirectory;
    in {
        enable = true;
        createDirectories = true;

        desktop = "${home}";
        documents = "${home}/documents";
        download = "${home}/downloads";
        music = "${home}/music";
        pictures = "${home}/pictures";
        publicShare = "${home}/public";
        videos = "${home}/videos";
        templates = "${home}/.config/templates";
    };
}
