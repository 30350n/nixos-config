{
    nixosConfig,
    pkgs,
    ...
}: {
    imports = [
        ./cpp.nix
        ./flutter.nix
        ./latex.nix
        ./markdown.nix
        ./nix.nix
        ./python.nix
        ./rust.nix
    ];

    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;

        mutableExtensionsDir = false;

        profiles.default = {
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;

            extensions = with pkgs.unstable.vscode-extensions; [
                mkhl.direnv
                tomoki1207.pdf
                (import ./marketplace-extensions/explorer-exclude.nix {inherit pkgs;})

                tamasfe.even-better-toml
            ];

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
                "editor.inlayHints.enabled" = "offUnlessPressed";

                "explorer.confirmDelete" = false;
                "explorer.confirmDragAndDrop" = false;

                "extensions.autoUpdate" = false;

                "files.exclude" = {
                    "**/.direnv/" = true;
                    "**/.jj/" = true;
                };
                "files.insertFinalNewline" = true;
                "files.trimFinalNewlines" = true;

                "git.enableStatusBarSync" = false;
                "git.blame.editorDecoration.enabled" = true;

                "keyboard.dispatch" = "keyCode";

                "security.workspace.trust.enabled" = false;

                "terminal.integrated.allowChords" = false;
                "terminal.integrated.defaultProfile.linux" = "fish";
                "terminal.integrated.scrollback" = 10000;
                "terminal.integrated.shellIntegration.enabled" = false;

                "update.showReleaseNotes" = false;

                "window.titleBarStyle" = "custom";
                "window.zoomLevel" = 1;

                "workbench.editor.empty.hint" = "hidden";
                "workbench.startupEditor" = "none";

                "direnv.restart.automatic" = true;

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
    };
}
