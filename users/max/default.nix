{pkgs, ...}: {
    users.users.max = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "dialout"];
        hashedPasswordFile = "/persist/passwords/max";
        packages = (
            (import ./packages.nix {inherit pkgs;})
            ++ (import ../work/packages.nix {inherit pkgs;})
        );
    };
}
