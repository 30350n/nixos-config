{
    config,
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

    programs.vscode.profiles.default.extensions = with (
        pkgs.nix-vscode-extensions.forVSCodeVersion config.programs.vscode.package.version
    ).vscode-marketplace;
        lib.mkForce [
            jnoortheen.nix-ide
            peterschmalfeldt.explorer-exclude
        ];

    home.stateVersion = "23.11";
}
