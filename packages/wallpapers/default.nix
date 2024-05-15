{stdenv}:
stdenv.mkDerivation {
    name = "wallpapers";
    src = ./.;
    installPhase = ''
        mkdir -p $out/share/backgrounds/
        cp *.png $out/share/backgrounds/
    '';
}
