{
    writeShellApplication,
    jujutsu,
    pre-commit,
    alejandra4,
}:
writeShellApplication {
    name = "rebuild";
    runtimeInputs = [jujutsu pre-commit alejandra4];
    text = builtins.readFile ./rebuild.sh;
}
