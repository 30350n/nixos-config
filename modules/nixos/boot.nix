{
    config,
    lib,
    pkgs,
    ...
}: {
    options.custom.boot.silent = lib.mkEnableOption "silentboot" // {default = true;};

    config.boot = lib.mkMerge [
        {
            loader = {
                timeout = 0;
                systemd-boot = {
                    enable = true;
                    configurationLimit = 10;
                };
                efi.canTouchEfiVariables = true;
            };
        }
        (lib.mkIf config.custom.boot.silent {
            plymouth = {
                enable = true;
                theme = "breeze";
                logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
                font = "${pkgs.custom.segoe-ui}/share/fonts/truetype/segoeui.ttf";
            };

            consoleLogLevel = 0;
            initrd.verbose = false;
            kernelParams = [
                "quiet"
                "rd.udev.log_level=3"
                "log_level=3"
                "systemd.show_status=false"
            ];
        })
    ];
}
