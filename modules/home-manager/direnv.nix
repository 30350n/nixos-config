{config, ...}: {
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = config.programs.nushell.enable;
        enableZshIntegration = config.programs.zsh.enable;

        config.global = {
            log_filter = "^$";
            warn_timeout = 0;
        };
    };
}
