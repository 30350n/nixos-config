{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        impermanence.url = "github:nix-community/impermanence";

        nix-vscode-extensions = {
            url = "github:nix-community/nix-vscode-extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-wallpaper = {
            url = "github:lunik1/nix-wallpaper";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.flake-utils.follows = "nix-vscode-extensions/flake-utils";
        };
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-unstable,
        home-manager,
        disko,
        impermanence,
        nix-vscode-extensions,
        nix-wallpaper,
        ...
    } @ inputs: let
        defaultModules = [
            ./packages
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
        ];
    in {
        nixosConfigurations = {
            thinkpad = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    hostName = "thinkpad";
                    inherit inputs;
                };
                modules = defaultModules ++ [./hosts/thinkpad/configuration.nix];
            };
        };
    };
}
