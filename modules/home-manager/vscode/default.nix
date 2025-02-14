{
    nixosConfig,
    pkgs,
    ...
}: {
    imports = [
        ./cpp.nix
        ./flutter.nix
        ./git.nix
        ./latex.nix
        ./markdown.nix
        ./nix.nix
        ./python.nix
        ./rust.nix
    ];

    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;

        extensions = with pkgs.vscode-extensions; [
            mkhl.direnv
            tomoki1207.pdf
            (import ./marketplace-extensions/explorer-exclude.nix {inherit pkgs;})

            tamasfe.even-better-toml
        ];

        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        mutableExtensionsDir = false;

        userSettings = let
            fonts = nixosConfig.fonts.fontconfig.defaultFonts.monospace;
        in {
            "editor.fontFamily" = ''
                ${builtins.concatStringsSep ", " (builtins.map (s: "'${s}'") fonts)}
            '';
            "editor.fontSize" = 13;
            "editor.rulers" = [100];
            "editor.wordWrapColumn" = 100;
            "editor.minimap.enabled" = false;
            "editor.formatOnSave" = true;

            "explorer.confirmDelete" = false;
            "explorer.confirmDragAndDrop" = false;

            "extensions.autoUpdate" = false;

            "files.exclude" = {
                "**/.direnv/" = true;
                "**/.jj/" = true;
            };
            "files.insertFinalNewline" = true;
            "files.trimFinalNewlines" = true;

            "keyboard.dispatch" = "keyCode";

            "security.workspace.trust.enabled" = false;

            "terminal.integrated.allowChords" = false;
            "terminal.integrated.defaultProfile.linux" = "fish";
            "terminal.integrated.scrollback" = 10000;
            "terminal.integrated.shellIntegration.enabled" = false;

            "window.titleBarStyle" = "custom";
            "window.zoomLevel" = 1;

            "workbench.editor.empty.hint" = "hidden";
            "workbench.startupEditor" = "none";

            "evenBetterToml.formatter.columnWidth" = 100;
            "evenBetterToml.formatter.arrayAutoCollapse" = true;
            "evenBetterToml.formatter.arrayTrailingComma" = true;

            "explorerExclude.showPicker" = false;
        };

        keybindings = [
            {
                key = "alt+left";
                command = "workbench.action.navigateBack";
                when = "canNavigateBack";
            }
            {
                key = "alt+right";
                command = "workbench.action.navigateForward";
                when = "canNavigateForward";
            }
            {
                key = "ctrl+t";
                command = "workbench.action.terminal.toggleTerminal";
                when = "terminal.active";
            }
        ];
    };
}
