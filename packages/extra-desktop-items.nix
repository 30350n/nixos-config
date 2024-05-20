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
                desktopName = "shutdown";
                exec = "shutdown now";
            })
            (makeDesktopItem {
                name = "reboot";
                desktopName = "reboot";
                exec = "reboot";
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
