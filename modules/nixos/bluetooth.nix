{
    config,
    lib,
    ...
}:
lib.mkIf config.custom.bluetooth {
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };
}
