{
    config,
    lib,
    pkgs,
    ...
}: {
    options.custom.ddcutil.enable =
        lib.mkEnableOption "ddcutil"
        // {
            default = !config.custom.isLaptop;
        };

    config = lib.mkIf config.custom.ddcutil.enable {
        hardware.i2c.enable = true;
        environment.systemPackages = with pkgs; [ddcutil ddcui];
        services.udev.packages = with pkgs; [ddcutil];
    };
}
