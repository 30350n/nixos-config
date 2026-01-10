{
    stdenvNoCC,
    fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
    pname = "gnome-shell-extension-multi-monitors-add-on";
    version = "27";

    src = fetchFromGitHub {
        owner = "lazanet";
        repo = "multi-monitors-add-on";
        rev = "67af601899ebc52562e42b34037f0b0967f89acd";
        sha256 = "4nZTfPoC39ay3Iu+YKS3BholrxLbaP4Tjxweyq+yFIg=";
    };

    patches = [
        ./panel-bottom.patch
        ./panel-children.patch
    ];

    passthru = {
        extensionUuid = "multi-monitors-add-on@lazanet";
        extensionPortalSlug = "multi-monitors-add-on";
    };

    installPhase = let
        out = "$out/share/gnome-shell/extensions/${passthru.extensionUuid}";
    in ''
        mkdir -p "${out}"
        cp -r multi-monitors-add-on@spin83/* "${out}"
        substituteInPlace "${out}/metadata.json" \
            --replace-fail '["45", "46"]' '["45", "46", "47", "48", "49"]'
        for file in $(find "${out}" -type f \( -name "*.js" -o -name "*.json" \)); do
            substituteInPlace "$file" --replace-quiet "spin83" "lazanet"
        done
    '';
}
