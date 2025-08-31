{
    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocales = ["de_DE.UTF-8/UTF-8" "en_DK.UTF-8/UTF-8"];
    i18n.extraLocaleSettings = {
        LC_CTYPE = "en_US.UTF-8";
        LC_ADDRESS = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MESSAGES = "en_US.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "en_DK.UTF-8";
        LC_COLLATE = "en_US.UTF-8";
    };

    services.xserver.xkb = {
        layout = "de";
        variant = "nodeadkeys";
    };
    console.useXkbConfig = true;
}
