{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            pkgs.unfree.vscode-extensions.ms-vscode.cpptools
            twxs.cmake
            (import ./marketplace-extensions/platformio-ide.nix {inherit pkgs;})
            (import ./marketplace-extensions/qml.nix {inherit pkgs;})
        ];

        userSettings = {
            "platformio-ide.useBuiltinPIOCore" = false;
            "platformio-ide.disablePIOHomeStartup" = true;
            "platformio-ide.useBuiltinPython" = false;

            "files.exclude" = {
                ".platformio/" = true;
            };
        };
    };

    programs.git.ignores = [
        ".io/"
        ".platformio/"
    ];
}
