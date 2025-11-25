{pkgs, ...}: {
    home-manager.users.max = ./home.nix;

    users.users.max = {
        isNormalUser = true;
        extraGroups = ["dialout" "gamemode"];
        hashedPasswordFile = "/persist/passwords/max";
        packages = (
            (import ./packages.nix {inherit pkgs;})
            ++ (import ../work/packages.nix {inherit pkgs;})
        );
    };
}
