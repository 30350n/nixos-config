{
    config,
    pkgs,
    lib,
    ...
} @ inputs: {
    programs.home-manager.enable = true;

    imports = [
        ../../modules/home-manager/fish.nix
        ../../modules/home-manager/git.nix
        ../../modules/home-manager/jujustu.nix
        ../../modules/home-manager/vscode
        ../../modules/home-manager/zoxide.nix
    ];

    gtk = {
        enable = true;
        theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
        };
    };
    dconf = {
        enable = true;
        settings = import ../../modules/shared/dconf-settings.nix inputs;
    };

    programs.vscode.profiles.default.extensions = with (
        pkgs.nix-vscode-extensions.forVSCodeVersion config.programs.vscode.package.version
    ).vscode-marketplace;
        lib.mkForce [
            jnoortheen.nix-ide
            peterschmalfeldt.explorer-exclude
            mkhl.shfmt
            ms-python.python
            detachhead.basedpyright
            charliermarsh.ruff
        ];

    home.stateVersion = "23.11";
}
