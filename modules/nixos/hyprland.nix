{
    config,
    pkgs,
    ...
}: {
    programs.hyprland.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs;
        [
            tofi
            hyprpaper
            custom.extra-desktop-items
            custom.mate.mate-polkit
        ]
        ++ (
            if config.hardware.bluetooth.enable
            then [blueberry]
            else []
        );

    security.polkit.enable = true;
    systemd.user.services.polkit-mate-authentication-agent-1 = {
        description = "Polkit Authentication Agent";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
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
}
