{
    writeShellApplication,
    jujutsu,
    pre-commit,
    alejandra4,
    jq,
}:
writeShellApplication {
    name = "rebuild";
    runtimeInputs = [jujutsu pre-commit alejandra4 jq];
    text = builtins.readFile ./rebuild.sh;
}
