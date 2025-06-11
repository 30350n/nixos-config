{pkgs, ...}: {
    programs.vscode.profiles.default = {
        extensions = with pkgs.vscode-extensions; [
            davidanson.vscode-markdownlint
            pkgs.vscode-extensions.bierner.github-markdown-preview
        ];

        userSettings = {
            "markdownlint.config" = {
                "MD014" = false; # commands-show-output
                "MD033" = false; # no-inline-html
                "MD041" = false; # first-line-heading/first-line-h1
            };

            "[markdown]" = {
                "editor.wordWrap" = "bounded";
            };
        };
    };
}
