{
    config,
    lib,
    pkgs,
    ...
}: let
    git = pkgs.git.override {withSsh = true;};
    src = "git@github.com:30350n/prusa-slicer-config.git";
    prusa_slicer_config = "${config.xdg.configHome}/PrusaSlicer";
in {
    home.activation.initPrusaSlicerConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -d "${prusa_slicer_config}/.git" ]; then
            run rm -rf "${prusa_slicer_config}"
            run ${git}/bin/git clone "${src}" "${prusa_slicer_config}"
        fi
        if [ ! -d ${prusa_slicer_config}/.jj ]; then
            run ${pkgs.jujutsu}/bin/jj git init --colocate "${prusa_slicer_config}"
        fi
    '';
}
