{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        unstable.jujutsu
        custom.configure
        custom.rebuild

        alacritty
        custom.extra-desktop-items
        firefox
        unstable.python312Full
    ];

    programs = {
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
