{
    fetchzip,
    lib,
    pkgs,
    wrapWine,
    ...
}: let
    version = "11.3.42";
    majorVersion = lib.versions.major version;
    edition = "suite";
    editionName = "Live ${majorVersion} ${lib.strings.toSentenceCase edition}";
    src = fetchzip {
        url = "https://cdn-downloads.ableton.com/channels/${version}/ableton_live_${edition}_${version}_64.zip";
        sha256 = "b/F94U7VODskaWxlK6/j3qTdh9nF6iH98fr05WKgb/c=";
        stripRoot = false;
    };
in
    wrapWine {
        name = "ableton-live-${majorVersion}-${edition}";
        desktopName = "Ableton ${editionName}";
        desktopIcon = ./icon.png;
        wine = pkgs.wineWowPackages.yabridge;
        tricks = ["quicktime72"];

        installScript = ''
            wine64 "${src}/Ableton ${editionName} Installer.exe" || true
        '';

        script = let
            pw-jack = "${pkgs.pipewire.jack}/bin/pw-jack";
        in ''
            ${pw-jack} wine "C:/ProgramData/Ableton/${editionName}/Program/Ableton ${editionName}.exe"
        '';
    }
