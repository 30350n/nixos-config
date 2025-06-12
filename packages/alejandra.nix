{
    alejandra,
    writeShellApplication,
    writeText,
}:
writeShellApplication {
    name = "alejandra";
    text = let
        config = writeText "alejandra.toml" ''
            indentation = "FourSpaces"
        '';
    in ''
        ${alejandra}/bin/alejandra --experimental-config ${config} "$@"
    '';
}
