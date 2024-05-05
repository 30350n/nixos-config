{
    writeShellApplication,
    jujutsu,
    pre-commit,
    alejandra,
    jq,
    nix-output-monitor,
}:
writeShellApplication {
    name = "rebuild";
    runtimeInputs = [jujutsu pre-commit alejandra jq nix-output-monitor];
    text = builtins.readFile ./rebuild.sh;
}
