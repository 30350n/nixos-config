{pkgs}:
with pkgs; [
    unfree.zoom-us

    blender
    freecad
    kicad
    inkscape
    custom.openpnp
    custom.prusa-slicer
    custom.uvtools
    (nixos-core.makeWebApp {
        url = "fluiddpi.local";
        name = "fluidd";
        icon = "${fluidd.src}/docs/assets/images/logo.svg";
        icon-scale = 0.8;
    })
    (symlinkJoin {
        name = scrcpy.pname;
        paths = [scrcpy];
        postBuild = ''
            rm $out/share/applications/scrcpy-console.desktop
        '';
    })

    direnv
    custom.mkshell
]
