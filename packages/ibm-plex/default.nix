{pkgs}:
pkgs.ibm-plex.overrideAttrs (finalAttrs: prevAttrs: {
    description = prevAttrs.meta.description + " (Mono with λ and ʌ)";
    src = [prevAttrs.src ./.];
    sourceRoot = ".";
    installPhase = ''
        install -Dm644 source/*/*.otf -t $out/share/fonts/opentype
        install -Dm644 source/IBM-Plex-Sans-JP/unhinted/* -t $out/share/fonts/opentype
        install -Dm644 ibm-plex/*.otf -t $out/share/fonts/opentype
    '';
})
