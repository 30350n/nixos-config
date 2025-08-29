{
    pkgs,
    extensions,
    ...
}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
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
