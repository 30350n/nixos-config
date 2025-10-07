{
    config,
    lib,
    ...
} @ inputs: {
    services.xserver.displayManager.gdm.enable = true;

    systemd.tmpfiles.rules = let
        accountsServiceDir = "/var/lib/AccountsService";
        userIcon = name: builtins.toString ../../users/${name}/face.png;
        userFile = name: (builtins.replaceStrings ["\n"] ["\\n"] ''
            [User]
            Session=gnome
            SystemAccount=false
            Icon=${accountsServiceDir}/icons/${name}
        '');
    in
        lib.lists.flatten (map (user: [
            "C ${accountsServiceDir}/icons/${user.name} 0644 root root - ${userIcon user.name}"
            "f ${accountsServiceDir}/users/${user.name} 0644 root root - - ${userFile user.name}"
        ]) (builtins.filter (user: user.isNormalUser) (builtins.attrValues config.users.users)));

    programs.dconf = {
        enable = true;
        profiles.gdm.databases = [{settings = import ../shared/dconf-settings.nix inputs;}];
    };
}
