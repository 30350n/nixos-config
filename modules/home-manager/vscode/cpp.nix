{
    pkgs,
    extensions,
    ...
}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
            llvm-vs-code-extensions.vscode-clangd
            twxs.cmake
            platformio.platformio-ide
            bbenoist.qml
        ];

        userSettings = {
            "clangd.path" = "${pkgs.clang-tools}/bin/clangd";

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
