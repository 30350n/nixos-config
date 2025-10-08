{
    config,
    lib,
    pkgs,
    ...
}: let
    git = pkgs.git.override {withSsh = true;};
    url-http = "https://github.com/30350n/prusa-slicer-config.git";
    url-ssh = "git@github.com:30350n/prusa-slicer-config.git";
    prusa_slicer_config = "${config.xdg.configHome}/PrusaSlicer";
in {
    home.activation.initPrusaSlicerConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -d "${prusa_slicer_config}/.git" ]; then
            run rm -rf "${prusa_slicer_config}"
            run ${git}/bin/git clone "${url-http}" "${prusa_slicer_config}"
            run ${git}/bin/git set-url origin ${url-ssh}
        fi
        if [ ! -d ${prusa_slicer_config}/.jj ]; then
            run ${pkgs.jujutsu}/bin/jj git init --colocate "${prusa_slicer_config}"
        fi
    '';
}
