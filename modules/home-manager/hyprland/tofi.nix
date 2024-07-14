{
    config,
    lib,
    ...
}: {
    programs.tofi = {
        enable = true;
        settings = {
            width = "100%";
            height = "100%";
            border-width = 0;
            outline-width = 0;
            padding-left = "35%";
            padding-top = "35%";
            result-spacing = 25;
            num-results = 5;
            background-color = "#000A";
            prompt-text = "\"λ \"";
        };
    };

    home.activation.clearTofiCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run rm -f ${config.xdg.cacheHome}/tofi-drun
    '';
}
