{pkgs, ...}: {
    imports = [
        ../../modules/nixos/docker.nix
        ../../modules/nixos/udev.nix
    ];

    users.users.bobbe = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "dialout"];
        hashedPasswordFile = "/persist/passwords/bobbe";
        packages = (
            (import ./packages.nix {inherit pkgs;})
            ++ (import ../work/packages.nix {inherit pkgs;})
        );
    };

    fonts = {
        packages = with pkgs; [
            custom.segoe-ui
            custom.ibm-plex
            custom.nerd-fonts.blex-mono
        ];
        fontconfig.defaultFonts = {
            serif = ["IBM Plex Serif"];
            sansSerif = ["Segoe UI Variable"];
            monospace = ["IBM Plex Mono" "BlexMono Nerd Font"];
        };
    };

    programs.steam = {
        enable = true;
        package = pkgs.unfree.steam;
    };
}
