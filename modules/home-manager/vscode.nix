{
    nixosConfig,
    pkgs,
    ...
}: {
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;

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

            "files.exclude" = {
                ".direnv/" = true;
                ".history/" = true;
            };

            "security.workspace.trust.enabled" = false;

            "terminal.integrated.scrollback" = 10000;
            "terminal.integrated.defaultProfile.linux" = "fish";
            "terminal.integrated.shellIntegration.enabled" = false;

            "window.titleBarStyle" = "custom";

            "workbench.editor.empty.hint" = "hidden";

            "extensions.autoUpdate" = false;

            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "${pkgs.unstable.nil}/bin/nil";
            "nix.serverSettings" = {
                "nil" = {
                    "formatting" = {
                        "command" = ["${pkgs.custom.alejandra4}/bin/alejandra"];
                    };
                };
            };

            "[nix]" = {
                "editor.tabSize" = 4;
            };
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

        extensions = with pkgs.vscode-extensions;
            [
                jnoortheen.nix-ide
                ms-python.python
                xyz.local-history
                mkhl.direnv
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                    name = "blender-development";
                    publisher = "JacquesLucke";
                    version = "0.0.20";
                    sha256 = "UQzTwPZyElzwtWAjbkHIsun+VEttlph4Og6A6nFxk8w=";
                }
            ];
    };

    home.packages = with pkgs; [
        unstable.nil
        custom.alejandra4
    ];
}
