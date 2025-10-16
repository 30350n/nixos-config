{config, ...}: {
    xdg.userDirs = let
        home = config.home.homeDirectory;
    in {
        enable = true;
        createDirectories = true;

        desktop = "${home}";
        documents = "${home}/documents";
        download = "${home}/downloads";
        music = "${home}/music";
        pictures = "${home}/pictures";
        publicShare = "${home}/public";
        videos = "${home}/videos";
        templates = "${home}/.config/templates";
    };

    home.sessionVariables = {
        CARGO_HOME = "\"$XDG_DATA_HOME\"/cargo";
        GRADLE_USER_HOME = "\"$XDG_DATA_HOME\"/gradle";
        HISTFILE = "\"$XDG_DATA_HOME\"/.bash_history";
        JAVA_TOOL_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_DATA_HOME\"/java";
        JULIA_DEPOT_PATH = "\"$XDG_DATA_HOME\"/julia:$JULIA_DEPOT_PATH";
        JULIAUP_DEPOT_PATH = "\"$XDG_DATA_HOME\"/julia";
        PYTHON_HISTORY = "\"$XDG_DATA_HOME\"/python/history";
        PYTHONPYCACHEPREFIX = "\"$XDG_DATA_HOME\"/python";
        PYTHONUSERBASE = "\"$XDG_DATA_HOME\"/python";
    };
}
