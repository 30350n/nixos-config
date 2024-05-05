{
    boot = {
        loader = {
            systemd-boot.enable = true;
            systemd-boot.configurationLimit = 10;
            efi.canTouchEfiVariables = true;
            timeout = 0;
        };

        plymouth = {
            enable = true;
            theme = "breeze";
        };

        consoleLogLevel = 0;
        initrd.verbose = false;
        kernelParams = [
            "quiet"
            "rd.udev.log_level=3"
            "log_level=3"
            "systemd.show_status=false"
        ];
    };
}
