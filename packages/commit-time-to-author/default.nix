{
    writeShellApplication,
    jujutsu,
}:
writeShellApplication {
    name = "commit-time-to-author";
    runtimeInputs = [jujutsu];
    text = builtins.readFile ./commit-time-to-author.sh;
}
