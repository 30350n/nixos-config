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

    environment.systemPackages = with pkgs; [
        custom.sddm-theme
    ];
}
