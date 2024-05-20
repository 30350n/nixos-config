{pkgs, ...}: {
    programs.fish.enable = true;
    programs.bash.interactiveShellInit = ''
        _parent=$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm)
        if [[ $_parent != "fish" && $_parent != "codium" && -z "''${BASH_EXECUTION_STRING}" ]]
        then
            unset _parent
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
        unset _parent
    '';

    environment.variables = let
        nix-shell_fake_bash = pkgs.writeShellScript "nix-shell_fake_bash" ''
            bash "$@" -ci "${pkgs.fish}/bin/fish"
        '';
    in {
        PAGER = "less -FrX";
        NIX_BUILD_SHELL = nix-shell_fake_bash;
    };
}
