{
    config,
    nixosConfig,
    pkgs,
    ...
} @ args: let
    extensions =
        pkgs.nix-vscode-extensions.forVSCodeVersion config.programs.vscode.package.version;
in {
    imports = map (file: import file (args // {inherit extensions;})) [
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
        package = pkgs.unstable.vscodium;

        mutableExtensionsDir = false;

        profiles.default = {
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;

            extensions = with extensions.vscode-marketplace; [
                mkhl.direnv
                tomoki1207.pdf
                peterschmalfeldt.explorer-exclude

                tamasfe.even-better-toml
                editorconfig.editorconfig
                mkhl.shfmt
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

                "shfmt.executablePath" = "${pkgs.shfmt}/bin/shfmt";
                "shfmt.executableArgs" = [
                    "--indent=4"
                    "--simplify"
                    "--case-indent"
                    "--space-redirects"
                ];
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
