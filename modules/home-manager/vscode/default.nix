{
    nixosConfig,
    pkgs,
    ...
}: {
    imports = [
        ./cpp.nix
        ./markdown.nix
        ./nix.nix
        ./python.nix
    ];

    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;

        extensions = with pkgs.vscode-extensions; [
            mkhl.direnv
            xyz.local-history
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
            };

            "keyboard.dispatch" = "keyCode";

            "security.workspace.trust.enabled" = false;

            "terminal.integrated.scrollback" = 10000;
            "terminal.integrated.defaultProfile.linux" = "fish";
            "terminal.integrated.shellIntegration.enabled" = false;

            "window.titleBarStyle" = "custom";

            "workbench.editor.empty.hint" = "hidden";
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
