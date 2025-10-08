{
    config,
    lib,
    ...
}:
lib.mkIf config.custom.nvidia.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.open = true;

    nixos-core.allowUnfree = ["nvidia-x11" "nvidia-settings"];
}
