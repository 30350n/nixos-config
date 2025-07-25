{
    pkgs,
    lib,
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

    programs.vscode.profiles.default.extensions = with pkgs.unstable.vscode-extensions;
        lib.mkForce [
            jnoortheen.nix-ide
            (import ../../modules/home-manager/vscode/marketplace-extensions/explorer-exclude.nix {inherit pkgs;})
        ];

    home.stateVersion = "23.11";
}
