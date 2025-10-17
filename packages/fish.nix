{pkgs}:
pkgs.symlinkJoin {
    name = "fish";
    paths = [pkgs.fish];
    postBuild = ''
        rm $out/share/applications/fish.desktop
    '';
}
