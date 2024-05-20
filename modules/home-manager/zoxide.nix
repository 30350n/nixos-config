{config, ...}: {
    programs.zoxide = {
        enable = true;
        options = ["--cmd cd"];
        enableBashIntegration = config.programs.bash.enable;
        enableFishIntegration = config.programs.fish.enable;
        enableNushellIntegration = config.programs.nushell.enable;
        enableZshIntegration = config.programs.zsh.enable;
    };
}
