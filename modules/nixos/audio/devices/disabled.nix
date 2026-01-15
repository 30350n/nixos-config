{
    config,
    lib,
    ...
}: {
    options.custom.audio = {
        devices.disabled = lib.mkOption {type = lib.types.nullOr (lib.types.listOf lib.types.str);};
    };

    config = lib.mkIf (config.custom.audio.devices.disabled != null) {
        services.pipewire.wireplumber.extraConfig = {
            "90-disabled-devices" = {
                "monitor.alsa.rules" = map (device: {
                    matches = [{"device.name" = device;}];
                    actions.update-props."device.disabled" = true;
                })
                config.custom.audio.devices.disabled;
            };
        };
    };
}
