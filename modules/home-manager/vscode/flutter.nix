{pkgs, ...}: {
    programs.vscode.profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
            dart-code.flutter
            dart-code.dart-code
            lokalise.i18n-ally
        ];

        userSettings = {
            "dart.checkForSdkUpdates" = false;
            "dart.enableSdkFormatter" = true;
            "dart.lineLength" = 100;
            "dart.closingLabelsPrefix" = " ";
            "dart.showTodos" = false;

            "i18n-ally.theme.annotation" = "#F5AB8E";
            "i18n-ally.theme.annotationBorder" = "#F5AB8E40";
        };
    };
}
