{
    config,
    lib,
    pkgs,
    ...
}:
lib.mkIf config.custom.steam.enable (lib.mkMerge [
    {
        programs = {
            steam = {
                enable = true;
                package = pkgs.unfree.steam;
            };
            gamemode.enable = true;
        };

        environment.systemPackages = with pkgs; [mangohud];
    }
    (lib.mkIf config.custom.nvidia.enable {
        boot.kernelParams = ["nvidia-drm.modeset=1"];
        boot.initrd.kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];
    })
])
