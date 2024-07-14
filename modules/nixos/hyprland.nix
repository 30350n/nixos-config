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

    systemd.services.sddm-user-icons = {
        before = ["display-manager.service"];
        wantedBy = ["display-manager.service"];
        serviceConfig.type = "simple";

        script = let
            iconsDir = "/var/lib/AccountsService/icons";
        in ''
            mkdir -p ${iconsDir}
            ${builtins.concatStringsSep "\n" (
                map (
                    user: "cp /home/${user.name}/.face.icon ${iconsDir}/${user.name}"
                ) (builtins.filter (
                    user: user.isNormalUser
                ) (builtins.attrValues config.users.users))
            )}
        '';
    };

    programs.hyprland.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs;
        [
            tofi
            hyprpaper
            custom.wallpapers
            custom.sddm-theme
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
