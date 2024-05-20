{pkgs, ...}: {
    programs.home-manager.enable = true;

    imports = [
        ../../modules/home-manager/hyprland
        ../../modules/home-manager/alacritty.nix
        ../../modules/home-manager/direnv.nix
        ../../modules/home-manager/fish.nix
        ../../modules/home-manager/git.nix
        ../../modules/home-manager/jujustu.nix
        ../../modules/home-manager/vscode.nix
        ../../modules/home-manager/zoxide.nix
    ];

    programs.tofi.settings.font = ''
        ${pkgs.custom.ibm-plex}/share/fonts/opentype/IBMPlexMono-Regular.otf
    '';

    home.stateVersion = "23.11";
}
