{
    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
        layout = "de";
        variant = "nodeadkeys";
    };
    console.useXkbConfig = true;
}
