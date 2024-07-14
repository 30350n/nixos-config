{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
        ];
        userSettings = {
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "${pkgs.unstable.nil}/bin/nil";
            "nix.serverSettings" = {
                "nil" = {
                    "formatting" = {
                        "command" = ["${pkgs.custom.alejandra4}/bin/alejandra" "-qq"];
                    };
                };
            };
            "[nix]" = {
                "editor.tabSize" = 4;
            };
        };
    };

    home.packages = with pkgs; [
        unstable.nil
        custom.alejandra4
    ];
}
