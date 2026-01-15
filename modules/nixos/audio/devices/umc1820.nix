{
    config,
    lib,
    ...
}: {
    options.custom.audio = {
        devices.umc1820.serial = lib.mkOption {type = lib.types.nullOr lib.types.str;};
    };

    config = lib.mkIf (config.custom.audio.devices.umc1820.serial != null) {
        services.pipewire.extraConfig.pipewire."95-umc1820-channel-remap" = let
            serial = config.custom.audio.devices.umc1820.serial;
            alsa_input = "alsa_input.usb-BEHRINGER_UMC1820_${serial}-00.multichannel-input";
            alsa_output = "alsa_output.usb-BEHRINGER_UMC1820_${serial}-00.multichannel-output";
        in {
            "context.modules" =
                (map (i: let
                    name = "UMC1820 IN ${toString (i * 2 + 1)}/${toString (i * 2 + 2)}";
                in {
                    name = "libpipewire-module-loopback";
                    args = {
                        "node.description" = name;
                        "capture.props" = {
                            "target.object" = alsa_input;
                            "node.passive" = true;
                            "audio.position" = [
                                "AUX${toString (i * 2)}"
                                "AUX${toString (i * 2 + 1)}"
                            ];
                        };
                        "playback.props" = {
                            "node.name" = name;
                            "media.class" = "Audio/Source";
                            "audio.position" = ["FL" "FR"];
                        };
                    };
                }) (lib.range 0 3))
                ++ (map (i: let
                    name = "UMC1820 IN ${toString (i + 1)}";
                in {
                    name = "libpipewire-module-loopback";
                    args = {
                        "node.description" = name;
                        "capture.props" = {
                            "target.object" = alsa_input;
                            "node.passive" = true;
                            "stream.dont-remix" = true;
                            "audio.position" = ["AUX${toString i}"];
                        };
                        "playback.props" = {
                            "node.name" = name;
                            "media.class" = "Audio/Source";
                            "audio.position" = ["MONO"];
                        };
                    };
                }) (lib.range 0 7))
                ++ (map (i: let
                    name = "UMC1820 OUT ${toString (i * 2 + 1)}/${toString (i * 2 + 2)}";
                in {
                    name = "libpipewire-module-loopback";
                    args = {
                        "node.description" = name;
                        "capture.props" = {
                            "node.name" = name;
                            "media.class" = "Audio/Sink";
                            "audio.position" = ["FL" "FR"];
                        };
                        "playback.props" = {
                            "target.object" = alsa_output;
                            "node.passive" = true;
                            "stream.dont-remix" = true;
                            "audio.position" = [
                                "AUX${toString (i * 2)}"
                                "AUX${toString (i * 2 + 1)}"
                            ];
                        };
                    };
                }) (lib.range 0 4));
        };
    };
}
