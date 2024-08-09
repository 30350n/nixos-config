{pkgs, ...}: {
    programs.jujutsu = {
        enable = true;
        package = pkgs.custom.jujutsu;
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

            user = {
                name = "Bobbe";
                email = "maxschlecht@web.de";
            };
        };
    };
}
