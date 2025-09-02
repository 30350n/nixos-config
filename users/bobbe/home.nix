{pkgs, ...}: {
    programs.home-manager.enable = true;

    imports = [
        ../../modules/home-manager/alacritty.nix
        ../../modules/home-manager/direnv.nix
        ../../modules/home-manager/fish.nix
        ../../modules/home-manager/git.nix
        ../../modules/home-manager/gtk.nix
        ../../modules/home-manager/jujustu.nix
        ../../modules/home-manager/prusa-slicer.nix
        ../../modules/home-manager/vscode
        ../../modules/home-manager/zoxide.nix
    ];

    services.syncthing.enable = true;

    home.file.".face.icon" = {source = ./icon.jpg;};

    home.sessionVariables = {
        XDG_PROGRAMMING_DIR = "$HOME/programming";
        XDG_PROJECTS_DIR = "$HOME/projects";
    };

    programs.tofi.settings.font = ''
        ${pkgs.custom.ibm-plex}/share/fonts/opentype/IBMPlexMono-Regular.otf
    '';

    home.stateVersion = "23.11";
}
