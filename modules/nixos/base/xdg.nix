{
    environment.sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";

        CARGO_HOME = "\"$XDG_DATA_HOME\"/cargo";
        GRADLE_USER_HOME = "\"$XDG_DATA_HOME\"/gradle";
        HISTFILE = "\"$XDG_STATE_HOME\"/.bash_history";
        JAVA_TOOL_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java";
        JULIA_DEPOT_PATH = "\"$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH\"";
        JULIAUP_DEPOT_PATH = "\"$XDG_DATA_HOME\"/julia";
        PYTHON_HISTORY = "\"$XDG_STATE_HOME\"/python/history";
        PYTHONPYCACHEPREFIX = "\"$XDG_CACHE_HOME\"/python";
        PYTHONUSERBASE = "\"$XDG_DATA_HOME\"/python";
    };
}
