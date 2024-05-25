{pkgs, ...}: {
    programs.vscode = {
        extensions = [
            pkgs.unfree.vscode-extensions.ms-vscode.cpptools
        ];
}
