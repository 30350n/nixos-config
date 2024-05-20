{
    config,
    pkgs,
    ...
}: {
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "chili";
    };

    programs.hyprland.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs;
        [
            tofi
            hyprpaper
            custom.wallpapers
            custom.sddm-chili-theme
            polkit_gnome
        ]
        ++ (
            if config.hardware.bluetooth.enable
            then [blueberry]
            else []
        );

    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "Polkit Authentication Agent";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
        };
    };
}