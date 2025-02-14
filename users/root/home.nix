{
    lib,
    pkgs,
    ...
}: {
    programs.home-manager.enable = true;

    imports = [
        ../../modules/home-manager/fish.nix
        ../../modules/home-manager/git.nix
        ../../modules/home-manager/jujustu.nix
        ../../modules/home-manager/vscode
        ../../modules/home-manager/zoxide.nix
    ];

    programs.vscode.extensions = with pkgs.vscode-extensions;
        lib.mkForce [
            jnoortheen.nix-ide
            xyz.local-history
            eamodio.gitlens
            (import ../../modules/home-manager/vscode/marketplace-extensions/explorer-exclude.nix {inherit pkgs;})
        ];

    home.stateVersion = "23.11";
}
