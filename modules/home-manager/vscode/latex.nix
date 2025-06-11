{pkgs, ...}: {
    programs.vscode.profiles.default = {
        extensions = with pkgs.vscode-extensions; [
            james-yu.latex-workshop
            tecosaur.latex-utilities
        ];

        userSettings = {
            "[latex]" = {
                "editor.wordWrap" = "bounded";
            };
        };
    };
}
