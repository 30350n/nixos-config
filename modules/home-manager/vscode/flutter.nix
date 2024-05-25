{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            dart-code.flutter
            dart-code.dart-code
        ];

        userSettings = {
            "dart.checkForSdkUpdates" = false;
        };
    };
}
