{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            ms-python.python
            (import ./marketplace-extensions/blender-development.nix {inherit pkgs;})
        ];
    };
}
