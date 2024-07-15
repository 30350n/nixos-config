{
    nixosConfig,
    pkgs,
    ...
}: {
    imports = [
        ./cpp.nix
        ./flutter.nix
        ./markdown.nix
        ./nix.nix
        ./python.nix
        ./rust.nix
    ];

    programs.vscode = {
        enable = true;
        package = pkgs.custom.vscodium;

        extensions = with pkgs.vscode-extensions; [
            mkhl.direnv
            xyz.local-history

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
            "editor.rulers" = [96];
            "editor.minimap.enabled" = false;
            "editor.formatOnSave" = true;

            "explorer.confirmDelete" = false;
            "explorer.confirmDragAndDrop" = false;

            "extensions.autoUpdate" = false;

            "files.exclude" = {
                ".direnv/" = true;
                ".history/" = true;
                ".jj/" = true;
            };

            "keyboard.dispatch" = "keyCode";

            "security.workspace.trust.enabled" = false;

            "terminal.integrated.scrollback" = 10000;
            "terminal.integrated.defaultProfile.linux" = "fish";
            "terminal.integrated.shellIntegration.enabled" = false;

            "window.titleBarStyle" = "custom";
            "window.zoomLevel" = 1;

            "workbench.editor.empty.hint" = "hidden";
            "workbench.startupEditor" = "none";

            "evenBetterToml.formatter.columnWidth" = 96;
            "evenBetterToml.formatter.arrayAutoCollapse" = true;
            "evenBetterToml.formatter.arrayTrailingComma" = true;
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
