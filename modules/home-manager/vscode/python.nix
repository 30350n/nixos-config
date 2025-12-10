{extensions, ...}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
            ms-python.python
            ms-python.debugpy
            detachhead.basedpyright
            charliermarsh.ruff
            njpwerner.autodocstring
            ms-toolsai.jupyter
            jacqueslucke.blender-development
        ];

        userSettings = {
            "files.exclude" = {
                "**/.venv/" = true;
            };

            "python.terminal.shellIntegration.enabled" = false;

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
