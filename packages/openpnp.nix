{
    lib,
    fetchFromGitHub,
    jre,
    makeWrapper,
    maven,
}:
maven.buildMavenPackage rec {
    pname = "openpnp";
    version = "5dd12c7";

    src = fetchFromGitHub {
        owner = "openpnp";
        repo = pname;
        rev = version;
        hash = "sha256-5Wn2RoIjkEAFoZjjDPS46WGsYdCQYS+kTvGuxZKVe5M=";
    };

    mvnParameters = "-DskipTests";
    mvnHash = "sha256-G2D96W00TDb6e/hIsyVwl7UopizGccc0DH+cC8UE654=";

    nativeBuildInputs = [makeWrapper];

    openpnpJar = "openpnp-gui-0.0.1-alpha-SNAPSHOT.jar";
    installPhase = ''
        mkdir -p $out/bin $out/share/openpnp
        cp -r target/lib $out/share/openpnp/lib
        install -Dm644 target/${openpnpJar} $out/share/openpnp/${openpnpJar}

        makeWrapper ${jre}/bin/java $out/bin/openpnp \
            --add-flags "--add-opens=java.base/java.lang=ALL-UNNAMED" \
            --add-flags "--add-opens=java.desktop/java.awt=ALL-UNNAMED" \
            --add-flags "--add-opens=java.desktop/java.awt.color=ALL-UNNAMED" \
            --add-flags "-jar $out/share/openpnp/${openpnpJar}"
    '';

    meta = with lib; {
        description = "Open Source SMT Pick and Place Hardware and Software";
        homepage = "https://openpnp.org";
        license = licenses.gpl3Plus;
    };
}
