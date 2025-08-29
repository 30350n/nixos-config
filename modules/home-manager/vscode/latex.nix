{
    pkgs,
    extensions,
    ...
}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
            james-yu.latex-workshop
            tecosaur.latex-utilities
            ltex-plus.vscode-ltex-plus
        ];

        userSettings = {
            latex-workshop.formatting.latex = "tex-fmt";
            latex-workshop.formatting.tex-fmt.path = "${pkgs.tex-fmt}/bin/tex-fmt";
            latex-workshop.formatting.tex-fmt.args = ["--nowrap" "--tabsize" "4"];
            ltex.ltex-ls.path = pkgs.ltex-ls-plus;
            "[latex]" = {
                "editor.wordWrap" = "bounded";
            };
        };
    };
}
