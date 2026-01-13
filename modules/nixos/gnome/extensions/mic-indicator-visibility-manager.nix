{
    stdenvNoCC,
    fetchFromGitHub,
    pulseaudio,
}:
stdenvNoCC.mkDerivation rec {
    pname = "gnome-shell-extension-mic-indicator-visibility-manager";
    version = "0";

    src = fetchFromGitHub {
        owner = "moalhaddar";
        repo = "mic-indicator-visibilty-manager";
        rev = "732eb61c452025b80a0a5c1943fbec86137a05d8";
        sha256 = "ugowqcNU2+5litIQBoycaxQkypQE6UMjLE0QVKXXWtk=";
    };

    passthru = {
        extensionUuid = "mic-indicator-visibility-manager@alhaddar.dev";
        extensionPortalSlug = "mic-indicator-visibility-manager";
    };

    installPhase = let
        out = "$out/share/gnome-shell/extensions/${passthru.extensionUuid}";
    in ''
        mkdir -p ${out}
        cp -r * ${out}
        substituteInPlace "${out}/extension.js" \
            --replace-fail 'pactl list' '${pulseaudio}/bin/pactl list'
        substituteInPlace "${out}/metadata.json" --replace-fail '"46"' '"46", "47", "48", "49"'
    '';
}
