{pkgs, ...}: {
    programs.vscode.profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
            ms-python.python
            charliermarsh.ruff
            ms-toolsai.jupyter
            (import ./marketplace-extensions/basedpyright.nix {inherit pkgs;})
            (import ./marketplace-extensions/blender-development.nix {inherit pkgs;})
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
