{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        impermanence.url = "github:nix-community/impermanence";
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-unstable,
        disko,
        impermanence,
        ...
    } @ inputs: let
        system = "x86_64-linux";
        defaultModules = [
            {
                nixpkgs.overlays = [
                    (import ./packages)
                    (final: prev: {unstable = import nixpkgs-unstable {system = system;};})
                ];
            }
            (import ./modules/nixos/unfree.nix)
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
        ];
    in {
        nixosConfigurations = {
            thinkpad = nixpkgs.lib.nixosSystem rec {
                specialArgs = {
                    hostName = "thinkpad";
                    inherit inputs;
                };
                modules =
                    defaultModules
                    ++ [
                        ./hosts/thinkpad/configuration.nix
                    ];
            };
        };
    };
}
