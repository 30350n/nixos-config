{
    config,
    lib,
    ...
}:
lib.mkIf config.custom.audio.enable (
    lib.mkMerge [
        {
            services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
            };
        }
        (lib.mkIf config.custom.audio.realtime {
            security.rtkit.enable = true;
        })
    ]
)
