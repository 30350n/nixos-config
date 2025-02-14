{pkgs}:
pkgs.ibm-plex.overrideAttrs (finalAttrs: prevAttrs: {
    # TODO: use TTF
    description = prevAttrs.meta.description + " (Mono with λ and ʌ)";
    postInstall = let
        extra_fonts = pkgs.lib.fileset.toSource rec {
            root = ./.;
            fileset = pkgs.lib.fileset.fileFilter (file: file.hasExt "otf") root;
        };
    in
        (prevAttrs.postInstall or "")
        + ''
            install -Dm644 ${extra_fonts}/*.otf -t $out/share/fonts/opentype
        '';
})
