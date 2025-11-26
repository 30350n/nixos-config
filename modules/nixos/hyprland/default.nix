{
    config,
    pkgs,
    lib,
    ...
}: {
    options.custom.hyprland = {
        enable = lib.mkEnableOption "hyprland";
        monitors = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
        };
    };

    config = lib.mkIf config.custom.hyprland.enable {
        programs.hyprland.enable = true;

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.systemPackages = with pkgs;
            lib.mkMerge [
                [
                    (callPackage ./extra-desktop-items.nix {})
                    hyprpaper
                    custom.mate.mate-polkit
                    tofi
                ]
                (lib.mkIf config.hardware.bluetooth.enable [blueberry])
            ];

        security.polkit.enable = true;
        systemd.user.services.polkit-mate-authentication-agent-1 = {
            description = "Polkit Authentication Agent";
            wantedBy = ["graphical-session.target"];
            wants = ["graphical-session.target"];
            after = ["graphical-session.target"];
            unitConfig.ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland";
            serviceConfig = {
                Type = "simple";
                ExecStart = ''
                    ${pkgs.custom.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1
                '';
                Restart = "always";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };
    };
}
