{
    ffmpeg,
    writeShellApplication,
    yt-dlp,
    ...
}:
writeShellApplication {
    name = "yt-dlp-music";
    runtimeInputs = [yt-dlp ffmpeg];
    text = builtins.readFile ./yt-dlp-music.sh;
}
