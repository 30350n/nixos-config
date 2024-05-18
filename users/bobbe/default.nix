{pkgs, ...}: {
    users.users.bobbe = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager"];
        hashedPasswordFile = "/persist/passwords/bobbe";
        packages = (
            (import ./packages.nix {pkgs = pkgs;})
            ++ (import ../work/packages.nix {pkgs = pkgs;})
        );
    };

    #programs.steam = {
    #    enable = true;
    #    package = pkgs.unfree.steam;
    #};
}
