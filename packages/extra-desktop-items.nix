{
    stdenv,
    makeDesktopItem,
}:
stdenv.mkDerivation {
    name = "extra-desktop-items";
    buildCommand = let
        desktopItems = [
            (makeDesktopItem {
                name = "shutdown";
                desktopName = "Shutdown";
                notShowIn = ["GNOME"];
                exec = "shutdown now";
            })
            (makeDesktopItem {
                name = "reboot";
                desktopName = "Reboot";
                notShowIn = ["GNOME"];
                exec = "reboot";
            })
            (makeDesktopItem {
                name = "logout";
                desktopName = "Logout";
                notShowIn = ["GNOME"];
                exec = "hyprctl dispatch exit";
            })
        ];
    in
        builtins.concatStringsSep "\n" (
            ["mkdir -p $out/share/applications"]
            ++ (map (
                desktopItem: "cp -a ${desktopItem}/share/applications/* $out/share/applications"
            )
            desktopItems)
        );
}
