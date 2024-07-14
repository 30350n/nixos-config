{pkgs}:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
        name = "vscode-pylance";
        publisher = "ms-python";
        version = "2024.4.102";
        sha256 = "gBmxM0vfNOoaAkwU43IXpSdpgi9D+1nQl50NgNlZzHk=";
    };

    nativeBuildInputs = with pkgs; [
        nodePackages.prettier
    ];

    prePatch = ''
        prettier -w dist/extension.bundle.js
    '';

    patches = [
        ./unblock-vscodium.patch
    ];
}
