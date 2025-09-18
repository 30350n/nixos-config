{flake-inputs, ...}: {
    imports = [
        ./audio.nix
        ./boot.nix
        ./fish.nix
        ./impermanence.nix
        ./networking.nix
        ./locale.nix
        ./packages.nix
        ./xdg.nix
    ];

    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "/persist/passwords/root";

    security.sudo.extraConfig = ''
        Defaults lecture = never
        Defaults env_keep += "EDITOR"
    '';

    nix.registry.unstable = {
        from = {
            type = "indirect";
            id = "unstable";
        };
        flake = flake-inputs.nixpkgs-unstable;
    };
    nix.nixPath = [
        "nixpkgs=${flake-inputs.nixpkgs.outPath}"
        "unstable=${flake-inputs.nixpkgs-unstable.outPath}"
    ];
    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "23.11";
}
