{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            davidanson.vscode-markdownlint
            (import ./marketplace-extensions/markdown-preview-github-styles.nix {inherit pkgs;})
        ];
    };
}
