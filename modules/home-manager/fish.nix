{pkgs, ...}: {
    programs.fish = {
        enable = true;
        plugins = [
            {
                name = "tide";
                src = pkgs.custom.fishPlugins.tide;
            }
        ];

        shellAliases = {
            cat = "bat -pp";
            ls = "eza -l";
            la = "eza -la";
            laa = "eza -laa";
        };

        functions = {
            _tide_item_jj = let
                jj_log = args: "jj log --no-graph --color=always -r @ -T ${args} 2> /dev/null";
                bold = "set_color --bold";
                dim = "set_color --dim";
                normal = "set_color normal";
            in ''
                if not command -sq jj; or not jj root --quiet &> /dev/null
                    _tide_item_git
                    return 0
                end

                set conflict (${jj_log "'stringify(conflict)'"})
                set change_id (${jj_log "'format_short_id(change_id)'"})
                set bookmarks_tags (${jj_log "-r @-::@ 'bookmarks ++ tags'"})
                set modded (${jj_log "'diff.files().filter(|f| f.status() == \"modified\").len()'"})
                set added (${jj_log "'diff.files().filter(|f| f.status() == \"added\").len()'"})
                set removed (${jj_log "'diff.files().filter(|f| f.status() == \"removed\").len()'"})
                set copied (${jj_log "'diff.files().filter(|f| f.status() == \"copied\").len()'"})
                set renamed (${jj_log "'diff.files().filter(|f| f.status() == \"renamed\").len()'"})

                _tide_print_item jj $tide_jj_icon' ' (
                    test $conflict = "true"
                        and echo (set_color red --bold)"!"; or echo (set_color green --bold)"@"
                    echo -ns $change_id
                    test -n $bookmarks_tags;
                        and echo -ns (${dim})" ("(${normal})$bookmarks_tags(${dim})")"(${normal})
                    ${bold} $tide_jj_color_modified; test $modded != 0; and echo -ns " ~"$modded
                    ${bold} $tide_jj_color_added; test $added != 0; and echo -ns " +"$added
                    ${bold} $tide_jj_color_removed; test $removed != 0; and echo -ns " -"$removed
                    ${bold} $tide_jj_color_copied; test $copied != 0; and echo -ns "  "$copied
                    ${bold} $tide_jj_color_renamed; test $renamed != 0; and echo -ns "  "$renamed
                )
            '';

            _tide_item_sub_shell = let
                color = "(set_color $tide_sub_shell_color)";
            in ''
                set count -1
                set ppid (ps -p $fish_pid -o ppid= | string trim)
                while test (ps -p $ppid -o tty= | string trim) != ?
                    set ppid (ps -p $ppid -o ppid= | string trim)
                    set count (math $count + 1)
                end
                if test $count -gt 0
                    _tide_print_item sub_shell ${color}$tide_sub_shell_icon ${color}$count
                end
            '';
        };

        shellInit = ''
            functions --erase l ll

            set fish_greeting

            set tide_left_prompt_items pwd jj newline character
            set tide_right_prompt_items cmd_duration status direnv docker nix_shell python rustc \
                sub_shell

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

            set tide_direnv_icon " " # nf-cod-folder_active
            set tide_direnv_color brpurple
            set tide_direnv_color_denied brred
            set tide_direnv_bg_color normal
            set tide_direnv_bg_color_denied normal

            set tide_docker_icon  # nf-md-docker
            set tide_docker_default_contexts default
            set tide_docker_color brblue
            set tide_docker_bg_color normal

            set tide_git_icon " " # nf-oct-git_branch
            set tide_git_color_operation brred
            set tide_git_color_upstream brblue
            set tide_git_color_stash blue
            set tide_git_color_conflicted red
            set tide_git_color_staged green
            set tide_git_color_dirty yellow
            set tide_git_color_untracked cyan

            set tide_jj_icon " " # nf-oct-git_branch
            set tide_jj_color_modified yellow
            set tide_jj_color_added green
            set tide_jj_color_removed red
            set tide_jj_color_copied blue
            set tide_jj_color_renamed cyan

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

            set tide_sub_shell_icon ↑ # upwards arrow
            set tide_sub_shell_color cyan

            set tide_pwd_icon_unwritable  # nf-seti-lock
            set tide_pwd_markers .git .python-version .svn Cargo.toml go.mod build.zig

            set tide_python_icon  # nf-seti-python
            set tide_python_color blue
            set tide_python_bg_color normal

            set tide_rustc_icon  # nf-seti-rust
            set tide_rustc_color red
            set tide_rustc_bg_color normal

            set _make_sparse_prompt false
            function _sparse_prompt --on-event=fish_prompt
                if test "$_make_sparse_prompt" = true
                    echo
                else
                    set _make_sparse_prompt true
                end
            end

            function clear --wraps=clear
                set _make_sparse_prompt false
                command clear $argv
            end
        '';
    };

    home.packages = with pkgs; [
        custom.fishPlugins.tide
    ];

    xdg.desktopEntries.fish = {
        name = "fish";
        noDisplay = true;
    };
}
