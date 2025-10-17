{
    config,
    pkgs,
    ...
}: {
    programs.home-manager.enable = true;

    imports = [
        ../../modules/home-manager/alacritty.nix
        ../../modules/home-manager/direnv.nix
        ../../modules/home-manager/hyprland
        ../../modules/home-manager/git.nix
        ../../modules/home-manager/gnome.nix
        ../../modules/home-manager/jujustu.nix
        ../../modules/home-manager/prusa-slicer.nix
        ../../modules/home-manager/vscode
        ../../modules/home-manager/xdg.nix
    ];

    services.syncthing.enable = true;

    home.file.".face" = {source = ./face.png;};

    xdg.userDirs.extraConfig = {
        XDG_PROGRAMMING_DIR = "${config.home.homeDirectory}/programming";
        XDG_PROJECTS_DIR = "${config.home.homeDirectory}/projects";
    };

    programs.tofi.settings.font = ''
        ${pkgs.custom.ibm-plex}/share/fonts/opentype/IBMPlexMono-Regular.otf
    '';

    home.stateVersion = "23.11";
}
