{pkgs, ...}: {
    programs.fish.enable = true;
    programs.bash.interactiveShellInit = ''
        parent=$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm)
        if [[ $parent != "fish" && $parent != "codium" && -z ''${BASH_EXECUTION_STRING} ]]; then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
    '';
}
