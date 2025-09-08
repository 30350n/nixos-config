{stdenvNoCC}:
stdenvNoCC.mkDerivation {
    pname = "segoe-ui";
    version = "1.0";

    src = ./fonts;

    installPhase = ''
        runHook preInstall
        install -Dm644 $src/*.ttf -t $out/share/fonts/truetype
        runHook postInstall
    '';

    meta = rec {
        description = "The Microsoft Segoe UI font family";
        longDescription = ''
            ${description}
            Extracted from a Windows 10 22H2 ISO downloaded on 2025-07-25
        '';
        homepage = "https://learn.microsoft.com/typography/font-list/segoe-ui";
    };
}
