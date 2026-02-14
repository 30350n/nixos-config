{
    pkgs,
    extensions,
    ...
}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
            llvm-vs-code-extensions.vscode-clangd
            twxs.cmake
            mesonbuild.mesonbuild
            bbenoist.qml
        ];

        userSettings = {
            "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
            "mesonbuild.downloadLanguageServer" = false;
            "mesonbuild.languageServerPath" = "${pkgs.mesonlsp}/bin/mesonlsp";
        };
    };
}
