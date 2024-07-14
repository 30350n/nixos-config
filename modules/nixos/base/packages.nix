{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        custom.jujutsu
        custom.configure
        custom.rebuild

        alacritty
        bat
        custom.extra-desktop-items
        eza
        htop
        firefox
        gnome.file-roller
        krusader
        qview
        zoxide

        (unstable.python312Full.withPackages (python-pkgs: [
            python-pkgs.numpy
            python-pkgs.bpython
        ]))

        (cinnamon.nemo-with-extensions.override {
            nemo = custom.cinnamon.nemo;
            extensions = [
                cinnamon.nemo-emblems
                cinnamon.nemo-fileroller
                cinnamon.folder-color-switcher
            ];
        })
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

        nix-ld.enable = true;
    };

    services.gvfs.enable = true;
}
