{pkgs}:
with pkgs; [
    ungoogled-chromium
    thunderbird

    unstable.blender
    unstable.freecad
    unstable.kicad
    unstable.inkscape
    custom.openpnp

    direnv
    unfree.gitkraken
    custom.mkshell

    (vscode-with-extensions.override {
        vscode = vscodium;
        vscodeExtensions = with vscode-extensions;
            [
                ms-python.python
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                    name = "blender-development";
                    publisher = "JacquesLucke";
                    version = "0.0.20";
                    sha256 = "UQzTwPZyElzwtWAjbkHIsun+VEttlph4Og6A6nFxk8w=";
                }
            ];
    })
]
