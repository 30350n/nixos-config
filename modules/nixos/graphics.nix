{
    config,
    lib,
    ...
}: {
    options.custom.graphics = with lib; {
        multigpu = {
            enable = lib.mkEnableOption "multigpu";
            amdgpu = mkOption {type = types.str;};
            nvidiagpu = mkOption {type = types.str;};
            primary = mkOption {type = types.enum ["amd" "nvidia"];};
        };
        nvidia.enable = lib.mkEnableOption "nvidia";
    };

    config = let
        graphicsConfig = config.custom.graphics;
        toGpuBusId = with builtins;
            id: let
                matchedId = lib.lists.drop 1 (
                    match "(([0-9a-f]{4}):)?([0-9a-f]{2}):([0-9a-f]{2}).([0-9a-f])" id
                );
                ids = map toString (
                    map (id:
                        if id == null
                        then 0
                        else lib.fromHexString id)
                    matchedId
                );
            in "PCI:${elemAt ids 1}@${elemAt ids 0}:${elemAt ids 2}:${elemAt ids 3}";

        udevMatch = id: ''KERNEL=="card*", KERNELS=="${id}", SUBSYSTEM=="drm", SUBSYSTEMS=="pci"'';
        udevSettings = kind: primary:
            if kind == primary
            then ''SYMLINK+="dri/${kind}gpu", TAG+="mutter-device-preferred-primary"''
            else ''SYMLINK+="dri/${kind}gpu", TAG+="mutter-device-ignore"'';
    in
        lib.mkMerge [
            (lib.mkIf graphicsConfig.multigpu.enable (lib.mkMerge (with graphicsConfig.multigpu; [
                {
                    custom.graphics.nvidia.enable = true;

                    hardware.nvidia.powerManagement = {
                        enable = true;
                        finegrained = true;
                    };

                    services.udev.extraRules = ''
                        ${udevMatch amdgpu}, ${udevSettings "amd" primary}
                        ${udevMatch nvidiagpu}, ${udevSettings "nvidia" primary}
                    '';

                    environment.variables.AQ_DRM_DEVICES = "/dev/dri/${primary}gpu";
                }
                (lib.mkIf (primary == "amd") {
                    hardware.nvidia.prime = {
                        offload = {
                            enable = true;
                            enableOffloadCmd = true;
                        };
                        amdgpuBusId = toGpuBusId amdgpu;
                        nvidiaBusId = toGpuBusId nvidiagpu;
                    };
                })
            ])))
            (lib.mkIf graphicsConfig.nvidia.enable {
                hardware.graphics.enable = true;
                services.xserver.videoDrivers = ["nvidia"];
                hardware.nvidia.open = true;

                boot.kernelParams = ["nvidia-drm.modeset=1"];
                boot.initrd.kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];

                nixos-core.allowUnfree.regexes = ["nvidia-x11" "nvidia-settings"];
            })
        ];
}
