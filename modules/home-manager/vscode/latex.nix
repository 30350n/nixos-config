{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            james-yu.latex-workshop
            (import ./marketplace-extensions/latex-utilities.nix {inherit pkgs;})
        ];
    };
}
