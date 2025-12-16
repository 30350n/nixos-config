{
    config,
    lib,
    ...
} @ inputs: {
    services.displayManager.gdm.enable = true;

    systemd.tmpfiles.rules = let
        accountsServiceDir = "/var/lib/AccountsService";
        userIcon = name: ../../users/${name}/face.png;
        userFile = name: (builtins.replaceStrings ["\n"] ["\\n"] ''
            [User]
            Session=gnome
            SystemAccount=false
            Icon=${accountsServiceDir}/icons/${name}
        '');
        users = builtins.filter (user: user.isNormalUser) (builtins.attrValues config.users.users);
        monitorsFile = "/home/${(builtins.head users).name}/.config/monitors.xml";
    in
        (lib.lists.flatten (
            map (user: [
                "L+ ${accountsServiceDir}/icons/${user.name} - - - - ${userIcon user.name}"
                "f+ ${accountsServiceDir}/users/${user.name} 0644 root root - ${userFile user.name}"
            ])
            users
        ))
        ++ [
            "C+ /run/gdm/.config/monitors.xml - gdm gdm - ${monitorsFile}"
        ];

    programs.dconf = {
        enable = true;
        profiles.gdm.databases = [{settings = import ../shared/dconf-settings.nix inputs;}];
    };
}
