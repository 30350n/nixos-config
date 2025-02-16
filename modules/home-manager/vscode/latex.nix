{pkgs, ...}: {
    programs.vscode.profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
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
