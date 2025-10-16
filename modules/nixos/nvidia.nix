{
    config,
    lib,
    ...
}: {
    options.custom.nvidia.enable = lib.mkEnableOption "nvidia";

    config = lib.mkIf config.custom.nvidia.enable {
        hardware.graphics.enable = true;
        services.xserver.videoDrivers = ["nvidia"];
        hardware.nvidia.open = true;

        nixos-core.allowUnfree = ["nvidia-x11" "nvidia-settings"];
    };
}
