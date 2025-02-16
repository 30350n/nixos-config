{pkgs, ...}: {
    programs.vscode.profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
            pkgs.unstable.unfree.vscode-extensions.ms-vscode.cpptools
            twxs.cmake
            platformio.platformio-vscode-ide
            (import ./marketplace-extensions/qml.nix {inherit pkgs;})
        ];

        userSettings = {
            "platformio-ide.useBuiltinPIOCore" = false;
            "platformio-ide.disablePIOHomeStartup" = true;
            "platformio-ide.useBuiltinPython" = false;

            "files.exclude" = {
                "**/.platformio/" = true;
            };
        };
    };

    programs.git.ignores = [
        ".io/"
        ".platformio/"
    ];
}
