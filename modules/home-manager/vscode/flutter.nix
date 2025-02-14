{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            dart-code.flutter
            dart-code.dart-code
            lokalise.i18n-ally
        ];

        userSettings = {
            "dart.checkForSdkUpdates" = false;

            "i18n-ally.theme.annotation" = "#F5AB8E";
            "i18n-ally.theme.annotationBorder" = "#F5AB8E40";
        };
    };
}
