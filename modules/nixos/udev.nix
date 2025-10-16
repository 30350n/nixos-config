{pkgs, ...}: {
    services.udev.packages = with pkgs; [
        android-udev-rules
        openocd
        platformio-core.udev
        stlink
    ];

    users.groups = {
        adbusers = {};
        plugdev = {};
    };
}
