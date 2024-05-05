{
    lib,
    fetchzip,
    stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
    pname = "segoe-ui";
    version = "1.0";

    src = fetchzip {
        url = "https://aka.ms/SegoeUIVariable";
        extension = "zip";
        hash = "sha256-s82pbi3DQzcV9uP1bySzp9yKyPGkmJ9/m1Q6FRFfGxg=";
        curlOpts = "-L";
        stripRoot = false;
    };

    #preUnpack = "mv ";

    installPhase = ''
        runHook preInstall
        install -Dm644 SegoeUI-VF.ttf -t $out/share/fonts/truetype
        runHook postInstall
    '';

    meta = with lib; {
        description = "The Microsoft Segoe UI font family";
        homepage = "https://learn.microsoft.com/typography/font-list/segoe-ui";
    };
}
