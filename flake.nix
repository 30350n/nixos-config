{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        nixos-core = {
            url = "github:30350n/nixos-core";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
        };

        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        impermanence = {
            url = "github:nix-community/impermanence";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };

        nix-vscode-extensions = {
            url = "github:nix-community/nix-vscode-extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-wallpaper = {
            url = "github:lunik1/nix-wallpaper";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        nixpkgs,
        nixos-core,
        home-manager,
        disko,
        impermanence,
        ...
    } @ flake-inputs: let
        defaultModules = [
            nixos-core.nixosModules.nixos-core
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
                home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                };
            }
            impermanence.nixosModules.impermanence
            ./packages
        ];
        lib = nixos-core.lib;
    in {
        nixosConfigurations = {
            desktop = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    hostName = "desktop";
                    inherit flake-inputs lib;
                };
                modules = defaultModules ++ [./hosts/desktop/configuration.nix];
            };
            thinkpad = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    hostName = "thinkpad";
                    inherit flake-inputs lib;
                };
                modules = defaultModules ++ [./hosts/thinkpad/configuration.nix];
            };
        };
    };
}
