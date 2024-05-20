{
    lib,
    pkgs,
    ...
}: {
    programs.home-manager.enable = true;

    imports = [
        ../../modules/home-manager/fish.nix
        ../../modules/home-manager/vscode.nix
        ../../modules/home-manager/zoxide.nix
    ];

    programs.vscode.extensions = with pkgs.vscode-extensions;
        lib.mkForce [
            jnoortheen.nix-ide
        ];

    home.stateVersion = "23.11";
}
