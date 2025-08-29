{
    pkgs,
    extensions,
    lib,
    config,
    hostName,
    ...
}: {
    options = {
        vscode.nix.language-server = lib.mkOption {
            type = lib.types.enum ["nil" "nixd"];
            default = "nixd";
            description = "The language server to use for linting nix code in vscode.";
        };
    };
    config = let
        language-server = config.vscode.nix.language-server;
        language-server-package = pkgs.unstable.${language-server};
    in {
        programs.vscode.profiles.default = {
            extensions = with extensions.vscode-marketplace; [
                jnoortheen.nix-ide
            ];
            userSettings = {
                "nix.enableLanguageServer" = true;
                "nix.serverPath" = "${language-server-package}/bin/${language-server}";
                "nix.serverSettings" = {
                    "${language-server}" = lib.mkMerge [
                        {
                            formatting = {
                                command = ["${pkgs.custom.alejandra}/bin/alejandra" "-qq"];
                            };
                        }
                        (lib.mkIf (language-server == "nixd") {
                            options = rec {
                                nixos.expr =
                                    "(builtins.getFlake \"/etc/nixos/\")"
                                    + ".nixosConfigurations.${hostName}.options";
                                home-manager.expr =
                                    nixos.expr + ".home-manager.users.type.getSubOptions []";
                            };
                        })
                    ];
                };
                "nix.hiddenLanguageServerErrors" = [
                    "textDocument/definition"
                    "textDocument/documentSymbol"
                    "textDocument/formatting"
                ];
                "[nix]" = {
                    "editor.tabSize" = 4;
                };
            };
        };

        home.packages = with pkgs; [
            language-server-package
            custom.alejandra
        ];
    };
}
