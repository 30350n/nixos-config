{
    environment.sessionVariables = {
        XDG_DESKTOP_DIR = "$HOME";
        XDG_DOCUMENTS_DIR = "$HOME/documents";
        XDG_DOWNLOAD_DIR = "$HOME/downloads";
        XDG_MUSIC_DIR = "$HOME/music";
        XDG_PICTURES_DIR = "$HOME/pictures";
        XDG_PUBLICSHARE_DIR = "$HOME/public";
        XDG_VIDEOS_DIR = "$HOME/videos";
        XDG_TEMPLATES_DIR = "$HOME/.config/templates";

        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";

        CARGO_HOME = "$\{XDG_DATA_HOME\}/cargo";
        GRADLE_USER_HOME = "$\{XDG_DATA_HOME\}/gradle";
        HISTFILE = "$\{XDG_DATA_HOME\}/.bash_history";
        JAVA_TOOL_OPTIONS = "-Djava.util.prefs.userRoot=$\{XDG_DATA_HOME\}/java";
        JULIA_DEPOT_PATH = "$\{XDG_DATA_HOME\}/julia:$JULIA_DEPOT_PATH";
        JULIAUP_DEPOT_PATH = "$\{XDG_DATA_HOME\}/julia";
        PYTHON_HISTORY = "$\{XDG_DATA_HOME\}/python/history";
        PYTHONPYCACHEPREFIX = "$\{XDG_DATA_HOME\}/python";
        PYTHONUSERBASE = "$\{XDG_DATA_HOME\}/python";
    };
}
