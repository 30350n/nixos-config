{extensions, ...}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
            ms-python.python
            detachhead.basedpyright
            charliermarsh.ruff
            ms-toolsai.jupyter
            jacqueslucke.blender-development
        ];

        userSettings = {
            "files.exclude" = {
                "**/.venv/" = true;
            };

            "basedpyright.analysis.diagnosticMode" = "workspace";
            "basedpyright.analysis.typeCheckingMode" = "standard";

            "[python]" = {
                "editor.codeActionsOnSave" = {
                    "source.fixAll" = "always";
                    "source.organizeImports" = "always";
                };
            };
        };
    };
}
