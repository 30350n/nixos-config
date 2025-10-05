{
    imports = [
        ./audio.nix
        ./boot.nix
        ./fish.nix
        ./impermanence.nix
        ./networking.nix
        ./packages.nix
        ./xdg.nix
    ];

    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "/persist/passwords/root";

    system.stateVersion = "23.11";
}
