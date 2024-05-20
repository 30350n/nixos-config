{
    stdenv,
    writeShellApplication,
    makeDesktopItem,
}:
stdenv.mkDerivation rec {
    name = "configure-codium";
    buildCommand = let
        script = writeShellApplication {
            name = name;
            text = ''
                pkexec \
                    env WAYLAND_DISPLAY="$WAYLAND_DISPLAY" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
                        XDG_SESSION_TYPE="$XDG_SESSION_TYPE" \
                    codium /etc/nixos/ --no-sandbox --user-data-dir=.config/VSCodium
            '';
        };
        desktopEntry = makeDesktopItem {
            name = name;
            desktopName = "Configure";
            exec = "${script}/bin/${name}";
        };
    in ''
        mkdir -p $out/bin $out/share/applications
        cp ${script}/bin/${name} $out/bin/
        cp ${desktopEntry}/share/applications/${name}.desktop $out/share/applications/
    '';
}
