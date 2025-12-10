{extensions, ...}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
            davidanson.vscode-markdownlint
            bierner.github-markdown-preview
        ];

        userSettings = {
            "markdownlint.config" = {
                "MD014" = false; # commands-show-output
                "MD026" = false; # no-trailing-punctuation
                "MD033" = false; # no-inline-html
                "MD041" = false; # first-line-heading/first-line-h1
            };

            "[markdown]" = {
                "editor.wordWrap" = "bounded";
            };
        };
    };
}
