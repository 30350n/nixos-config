{config, ...}: {
    programs.zoxide = {
        enable = true;
        options = ["--cmd cd"];
        enableBashIntegration = true;
        enableFishIntegration = config.programs.fish.enable;
        enableNushellIntegration = config.programs.nushell.enable;
        enableZshIntegration = config.programs.zsh.enable;
    };
}
