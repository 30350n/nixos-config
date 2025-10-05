{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        nixos-core = {
            url = "github:30350n/nixos-core";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
        };

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
        nixos-core,
        home-manager,
        disko,
        impermanence,
        nix-vscode-extensions,
        nix-wallpaper,
        ...
    } @ flake-inputs: let
        defaultModules = [
            nixos-core.nixosModules.nixos-core
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
            ./packages
        ];
    in {
        nixosConfigurations = {
            desktop = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    hostName = "desktop";
                    inherit flake-inputs;
                };
                modules = defaultModules ++ [./hosts/desktop/configuration.nix];
            };
            thinkpad = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    hostName = "thinkpad";
                    inherit flake-inputs;
                };
                modules = defaultModules ++ [./hosts/thinkpad/configuration.nix];
            };
        };
    };
}
