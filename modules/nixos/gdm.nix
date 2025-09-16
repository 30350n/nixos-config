{
    config,
    lib,
    ...
}: {
    services.xserver.displayManager.gdm.enable = true;

    systemd.tmpfiles.rules = let
        accountsServiceDir = "/var/lib/AccountsService";
        userIcon = name: builtins.toString ../../users/${name}/face.png;
        userFile = name: ''
            [User]
            Session=gnome
            SystemAccount=false
            Icon=${accountsServiceDir}/icons/${name}
        '';
    in
        lib.lists.flatten (map (user: [
            "C ${accountsServiceDir}/icons/${user.name} 0644 root root - - ${userIcon user.name}"
            "f ${accountsServiceDir}/users/${user.name} 0644 root root - - '${userFile user.name}'"
        ]) (builtins.filter (user: user.isNormalUser) (builtins.attrValues config.users.users)));
    nixpkgs.overlays = [
        (finalPkgs: prevPkgs: {
            gnome-shell = import ../../packages/gnome-shell {pkgs = prevPkgs;};
        })
    ];
}
