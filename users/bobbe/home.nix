{pkgs, ...}: {
    programs.home-manager.enable = true;

    imports = [
        ../../modules/home-manager/hyprland
        ../../modules/home-manager/alacritty.nix
        ../../modules/home-manager/fish.nix
        ../../modules/home-manager/vscode.nix
    ];

    programs.tofi.settings.font = ''
        ${pkgs.custom.ibm-plex}/share/fonts/opentype/IBMPlexMono-Regular.otf
    '';

    home.stateVersion = "23.11";
}