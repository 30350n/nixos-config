{pkgs, ...}: {
    programs.fish = {
        enable = true;
        plugins = [
            {
                name = "tide";
                src = pkgs.custom.fishPlugins.tide;
            }
        ];

        shellInit = ''
            set fish_greeting

            set tide_left_prompt_items pwd git newline character
            set tide_right_prompt_items cmd_duration status direnv docker nix_shell python rustc

            set tide_prompt_icon_connection " "
            set tide_right_prompt_prefix " "
            set tide_right_prompt_separator_diff_color " "
            set tide_right_prompt_separator_same_color " "

            set tide_character_icon λ
            if fish_is_root_user
                set tide_character_color --bold red
            else
                set tide_character_color --bold green
            end
            set tide_character_color_failure $tide_character_color

            set tide_cmd_duration_decimals 2
            set tide_cmd_duration_threshold 1000

            set tide_direnv_icon  # nf-cod-folder_active
            set tide_direnv_color brcyan
            set tide_direnv_color_denied brred
            set tide_direnv_bg_color normal
            set tide_direnv_bg_color_denied normal

            set tide_docker_icon  # nf-md-docker
            set tide_docker_default_contexts default
            set tide_docker_color brblue
            set tide_docker_bg_color normal

            set tide_git_icon " " # nf-dev-git_branch
            set tide_git_color_location normal
            set tide_git_color_operation brred
            set tide_git_color_upstream brblue
            set tide_git_color_stash blue
            set tide_git_color_conflicted red
            set tide_git_color_staged green
            set tide_git_color_dirty yellow
            set tide_git_color_untracked cyan

            set tide_nix_shell_icon  # nf-md-nix
            set tide_nix_shell_color cyan
            set tide_nix_shell_bg_color normal

            set tide_status_display 2
            set tide_status_icon " " # nf-md-check_bold
            set tide_status_icon_failure " " # nf-fa-xmark
            set tide_status_color green
            set tide_status_color_failure red
            set tide_status_bg_color normal
            set tide_status_bg_color_failure normal

            set tide_pwd_icon_unwritable  # nf-seti-lock
            set tide_pwd_markers .git .python-version .svn Cargo.toml go.mod build.zig

            set tide_python_icon  # nf-seti-python
            set tide_python_color blue
            set tide_python_bg_color normal

            set tide_rustc_icon  # nf-seti-rust
            set tide_rustc_color red
            set tide_rustc_bg_color normal

            set _make_sparse_prompt false
        '';

        functions = {
            __sparse_prompt = {
                onEvent = "fish_prompt";
                body = ''
                    if test "$_make_sparse_prompt" = true
                        echo
                    else
                        set _make_sparse_prompt true
                    end
                '';
            };

            clear = {
                wraps = "clear";
                body = ''
                    set _make_sparse_prompt false
                    command clear $argv
                '';
            };
        };
    };

    home.packages = with pkgs; [
        custom.fishPlugins.tide
    ];
}
