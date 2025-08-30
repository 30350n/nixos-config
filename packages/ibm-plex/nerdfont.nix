{pkgs}:
pkgs.nerd-fonts.blex-mono.overrideAttrs (finalAttrs: prevAttrs: {
    nativeBuildInputs =
        (prevAttrs.nativeBuildInputs or [])
        ++ [pkgs.fontforge];

    installPhase = let
        outdir = "$out/share/fonts/truetype/NerdFonts/BlexMono";
    in ''
        mkdir -p ${outdir}
        find -type f -name '*.ttf' | while read file; do
            fontforge -lang=py -script ${./patch.py} $file ${outdir}
        done
    '';
})
