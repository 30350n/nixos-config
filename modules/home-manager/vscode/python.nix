{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            ms-python.python
            ms-python.isort
            ms-toolsai.jupyter
            (import ./marketplace-extensions/autopep8.nix {inherit pkgs;})
            (import ./marketplace-extensions/vscode-pylance {inherit pkgs;})
            (import ./marketplace-extensions/blender-development.nix {inherit pkgs;})
        ];

        userSettings = {
            "[python]" = {
                "editor.codeActionsOnSave" = {
                    "source.organizeImports" = "always";
                };
            };

            "files.exclude" = {
                ".venv/" = true;
            };
        };
    };
}
