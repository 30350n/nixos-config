{pkgs, ...}: {
    imports = [
        ../../modules/nixos/udev.nix
    ];

    users.users.bobbe = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager"];
        hashedPasswordFile = "/persist/passwords/bobbe";
        packages = (
            (import ./packages.nix {pkgs = pkgs;})
            ++ (import ../work/packages.nix {pkgs = pkgs;})
        );
    };

    fonts = {
        packages = with pkgs; [
            custom.segoe-ui
            custom.ibm-plex
            (nerdfonts.override {fonts = ["IBMPlexMono"];})
        ];
        fontconfig.defaultFonts = {
            serif = ["IBM Plex Serif"];
            sansSerif = ["Segoe UI Variable"];
            monospace = ["IBM Plex Mono" "BlexMono Nerd Font Mono"];
        };
    };

    #programs.steam = {
    #    enable = true;
    #    package = pkgs.unfree.steam;
    #};
}
