{pkgs}:
with pkgs; [
    ungoogled-chromium

    thunderbird
    unfree.zoom-us

    blender
    freecad
    kicad
    inkscape
    custom.openpnp
    custom.prusa-slicer
    custom.uvtools
    (pkgs.nixos-core.makeWebApp {
        url = "fluiddpi.local";
        name = "fluidd";
        icon = "${fluidd.src}/docs/assets/images/logo.svg";
        icon-scale = 0.8;
    })

    direnv
    custom.mkshell
]
