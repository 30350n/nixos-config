{pkgs, ...}: {
    services.udev.packages = with pkgs; [
        openocd
        platformio-core.udev
        stlink
    ];

    users.groups = {
        adbusers = {};
        plugdev = {};
    };
}
