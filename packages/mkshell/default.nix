{
    direnv,
    git,
    writeShellApplication,
}:
writeShellApplication {
    name = "mkshell";
    runtimeInputs = [direnv git];
    text = builtins.readFile ./mkshell.sh;
}
