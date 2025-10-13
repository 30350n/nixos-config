{
    config,
    lib,
    pkgs,
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
        (lib.mkIf (config.custom.audio.defaultVolume != null) {
            systemd.user.services.set-default-volume = let
                vol = builtins.toString (builtins.floor (config.custom.audio.defaultVolume * 100));
            in {
                script = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ ${vol}%";
                serviceConfig.Type = "oneshot";
                wantedBy = ["multi-user.target"];
            };
        })
    ]
)
