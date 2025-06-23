{
    config,
    lib,
    pkgs,
    ...
}: {
    boot = lib.mkMerge [
        {
            loader = {
                systemd-boot.enable = true;
                systemd-boot.configurationLimit = 10;
                efi.canTouchEfiVariables = true;
                timeout = 0;
            };
        }
        (lib.mkIf config.custom.boot.silent {
            plymouth = with pkgs; {
                enable = true;
                theme = "breeze";
                logo = "${nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
                font = "${custom.segoe-ui}/share/fonts/truetype/segoeui.ttf";
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
