{
    writeShellApplication,
    jujutsu,
    pre-commit,
}:
writeShellApplication {
    name = "rebuild";
    runtimeInputs = [jujutsu pre-commit];
    text = builtins.readFile ./rebuild.sh;
}
