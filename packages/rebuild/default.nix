{
    writeShellApplication,
    jujutsu,
    pre-commit,
    alejandra4,
    jq,
    nix-output-monitor,
}:
writeShellApplication {
    name = "rebuild";
    runtimeInputs = [jujutsu pre-commit alejandra4 jq nix-output-monitor];
    text = builtins.readFile ./rebuild.sh;
}
