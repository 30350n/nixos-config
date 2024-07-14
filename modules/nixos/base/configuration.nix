{
    imports = [
        ./audio.nix
        ./boot.nix
        ./fish.nix
        ./impermanence.nix
        ./networking.nix
        ./locale.nix
        ./packages.nix
    ];

    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "/persist/passwords/root";

    security.sudo.extraConfig = ''
        Defaults lecture = never
        Defaults env_keep += "EDITOR"
    '';

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "23.11";
}
