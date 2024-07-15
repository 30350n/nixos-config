{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            davidanson.vscode-markdownlint
            pkgs.vscode-extensions.bierner.github-markdown-preview
        ];
    };
}
