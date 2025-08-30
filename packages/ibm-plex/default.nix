{
    pkgs,
    truetype ? false,
}:
pkgs.ibm-plex.overrideAttrs (finalAttrs: prevAttrs: {
    nativeBuildInputs =
        (prevAttrs.nativeBuildInputs or [])
        ++ [pkgs.fontforge];

    installPhase = let
        font-extension =
            if truetype
            then "ttf"
            else "otf";
        outdir =
            if truetype
            then "$out/share/fonts/truetype"
            else "$out/share/fonts/opentype";
    in ''
        mkdir -p ${outdir}
        find $srcs -type f -name '*.${font-extension}' | while read file; do
            if [[ "$file" == *Mono* ]]; then
                fontforge -lang=py -script ${./patch.py} $file ${outdir}
            else
                install -Dm644 $file ${outdir}
            fi
        done
    '';
})
