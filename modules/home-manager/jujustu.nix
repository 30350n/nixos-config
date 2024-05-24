{
    programs.jujutsu = {
        enable = true;
        settings = {
            aliases = {
                all = ["log" "-r" "all()"];
                push = ["git" "push"];
            };

            revsets.log = "@ | ancestors(immutable_heads().., 17) | trunk()";

            user = {
                name = "Bobbe";
                email = "maxschlecht@web.de";
            };
        };
    };
}
