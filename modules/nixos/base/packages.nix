{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        custom.jujutsu
        custom.configure
        custom.rebuild

        alacritty
        bat
        custom.extra-desktop-items
        eza
        firefox
        unstable.python312Full
        zoxide
    ];

    programs = {
        bash.promptInit = ''
            PROMPT_COMMAND='GIT_PS1_CMD=$(__git_ps1 " (%s)")'
            if [[ $(id -u) == 0 ]]; then
                PS1='\n\w\[\e[33;1m\]''${GIT_PS1_CMD}\n\[\e[31;1m\]в\[\e[0m\] '
            else
                PS1='\n\w\[\e[33;1m\]''${GIT_PS1_CMD}\n\[\e[32;1m\]в\[\e[0m\] '
            fi
        '';

        command-not-found.enable = false;

        git = {
            enable = true;
            lfs.enable = true;
            prompt.enable = true;
        };

        nano = {
            enable = true;
            nanorc = ''
                set autoindent
                set linenumbers
                set tabsize 4
                set whitespace "→·"
            '';
        };
    };
}
