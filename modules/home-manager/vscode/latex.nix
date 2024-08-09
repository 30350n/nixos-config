{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            james-yu.latex-workshop
        ];
    };
}
