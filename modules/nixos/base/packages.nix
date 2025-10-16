{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        alacritty
        baobab
        eyedropper
        firefox
        file-roller
        krusader
        loupe
        localsend
        papers
        scrcpy
        simple-scan
        vlc

        (python3.withPackages (pythonPackages: [
            pythonPackages.numpy
            pythonPackages.bpython
        ]))
    ];
}
