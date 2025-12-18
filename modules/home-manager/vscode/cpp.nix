{
    pkgs,
    extensions,
    ...
}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
            llvm-vs-code-extensions.vscode-clangd
            twxs.cmake
            bbenoist.qml
        ];

        userSettings = {
            "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
        };
    };
}
