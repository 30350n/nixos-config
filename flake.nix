{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

        nixos-core = {
            url = "github:30350n/nixos-core";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
            inputs.impermanence.inputs.home-manager.follows = "home-manager";
        };

        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        musnix = {
            url = "github:musnix/musnix";
            inputs.nixpkgs.follows = "nixpkgs";
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
        determinate,
        nixos-core,
        home-manager,
        disko,
        musnix,
        ...
    } @ flake-inputs: let
        defaultModules = [
            determinate.nixosModules.default
            nixos-core.nixosModules.nixos-core
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            musnix.nixosModules.musnix
            {
                home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                };
            }
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
