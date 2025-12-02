{pkgs, ...}: {
    programs.jujutsu = {
        enable = true;
        settings = {
            aliases = {
                all = ["log" "-r" "all()"];
                wip = ["log" "-r" "wip()"];
                commit-time-to-author = let
                    command = "${pkgs.custom.commit-time-to-author}/bin/commit-time-to-author";
                in ["util" "exec" "--" command];
                word-diff = ["util" "exec" "--" "${pkgs.git}" "diff" "--word-diff=color"];
            };

            revsets.log = "@ | ancestors(immutable_heads().., 17) | trunk()";

            revset-aliases = {
                "wip()" = "::visible_heads() ~ ::bookmarks() ~ ::remote_bookmarks() ~ empty()";
            };

            templates.draft_commit_description = let
                draft_commit_description = ''

                    JJ: -------------------------------------------- ʌ ------------------- ʌ
                    JJ: max commit message length:   soft limit (50) ┘     hard limit (72) ┘

                    JJ: This commit contains the following changes:
                '';
            in ''
                concat(
                    description,
                    surround(
                        "${draft_commit_description}", "",
                        indent("JJ:     ", diff.stat(72)),
                    ),
                )
            '';

            ui = {
                default-command = "log";
                diff-editor = ":builtin";
            };

            user = {
                name = "Bobbe";
                email = "maxschlecht@web.de";
            };
        };
    };
}
