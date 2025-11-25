{
    config,
    lib,
    pkgs,
    ...
}: let
    url_http = "https://github.com/30350n/prusa-slicer-config.git";
    url_ssh = "git@github.com:30350n/prusa-slicer-config.git";
    prusa_slicer_config = "${config.xdg.configHome}/PrusaSlicer";
    init_prusa_slicer_config = pkgs.writeShellApplication {
        name = "init-prusa-slicer-config";
        runtimeInputs = with pkgs; [git jujutsu openssh];
        text = ''
            if [ ! -d "${prusa_slicer_config}/.git" ]; then
                run rm -rf "${prusa_slicer_config}"
                run git clone "${url_http}" "${prusa_slicer_config}"
                run git -C "${prusa_slicer_config}" remote set-url origin ${url_ssh}
            fi
            if [ ! -d ${prusa_slicer_config}/.jj ]; then
                run jj git init --colocate "${prusa_slicer_config}"
            fi
        '';
    };
in {
    home.activation.initPrusaSlicerConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${init_prusa_slicer_config}/bin/init-prusa-slicer-config
    '';
}
