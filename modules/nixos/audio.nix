{
    config,
    lib,
    pkgs,
    ...
}: {
    options.custom.audio = {
        enable = lib.mkEnableOption "audio" // {default = true;};
        realtime = lib.mkEnableOption "realtime" // {default = true;};
        defaultVolume = lib.mkOption {
            type = lib.types.nullOr lib.types.float;
            default = null;
        };
    };

    config = lib.mkIf config.custom.audio.enable (
        lib.mkMerge [
            {
                services.pipewire = {
                    enable = true;
                    alsa.enable = true;
                    alsa.support32Bit = true;
                    pulse.enable = true;
                    jack.enable = true;
                    extraConfig = let
                        bufferSize = 256;
                        sampleRate = 48000;
                        combined = "${toString bufferSize}/${toString sampleRate}";
                    in {
                        jack."10-low-latency"."jack.properties" = {
                            "node.latency" = combined;
                            "node.rate" = "1/${toString sampleRate}";
                            "node.lock-quantum" = true;
                        };
                        pipewire."10-low-latency"."context.properties" = {
                            "default.clock.rate" = sampleRate;
                            "default.clock.allowed-rates" = [
                                44100
                                48000
                            ];

                            "default.clock.quantum" = bufferSize;
                            "default.clock.min-quantum" = 16;
                            "default.clock.max-quantum" = 1024;
                        };
                        pipewire-pulse."10-low-latency" = {
                            "pulse.properties" = {
                                "pulse.min.req" = combined;
                                "pulse.default.req" = combined;
                                "pulse.max.req" = combined;
                                "pulse.min.quantum" = combined;
                                "pulse.max.quantum" = combined;
                            };
                            "stream.properties"."node.latency" = combined;
                        };
                    };
                };
                environment.systemPackages = with pkgs; [
                    helvum
                ];
            }
            (lib.mkIf config.custom.audio.realtime {
                security.rtkit.enable = true;
                users.groups.audio.members = builtins.attrNames config.users.users;
            })
            (lib.mkIf (config.custom.audio.defaultVolume != null) {
                systemd.user.services.set-default-volume = let
                    volume = toString (
                        builtins.floor (config.custom.audio.defaultVolume * 100)
                    );
                in {
                    script = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ ${volume}%";
                    serviceConfig.Type = "oneshot";
                    wantedBy = ["multi-user.target"];
                };
            })
        ]
    );
}
