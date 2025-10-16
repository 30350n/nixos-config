{pkgs, ...}: {
    fonts = {
        packages = with pkgs; [
            custom.ibm-plex
            custom.nerd-fonts.blex-mono
            custom.segoe-ui
        ];

        fontconfig.defaultFonts = {
            serif = ["IBM Plex Serif"];
            sansSerif = ["Segoe UI"];
            monospace = ["IBM Plex Mono" "BlexMono Nerd Font"];
        };
    };
}
