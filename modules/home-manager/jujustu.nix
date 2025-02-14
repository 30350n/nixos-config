{
    programs.jujutsu = {
        enable = true;
        settings = {
            aliases = {
                all = ["log" "-r" "all()"];
                push = ["git" "push"];
                wip = ["log" "-r" "wip()"];
            };

            revsets.log = "@ | ancestors(immutable_heads().., 17) | trunk()";

            revset-aliases = {
                "wip()" = "::visible_heads() ~ ::branches() ~ empty()";
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

            user = {
                name = "Bobbe";
                email = "maxschlecht@web.de";
            };
        };
    };
}
