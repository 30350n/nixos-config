{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        alacritty
        kdePackages.gwenview
        firefox
        file-roller
        krusader
        vlc

        (python3.withPackages (pythonPackages: [
            pythonPackages.numpy
            pythonPackages.bpython
        ]))
    ];
}
