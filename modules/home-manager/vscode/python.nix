{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            ms-python.python
            ms-toolsai.jupyter
            (import ./marketplace-extensions/vscode-pylance {inherit pkgs;})
            (import ./marketplace-extensions/blender-development.nix {inherit pkgs;})
        ];
    };
}
