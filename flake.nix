{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; #-23.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        impermanence = {
            url = "github:nix-community/impermanence";
        };
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
        pkgs = nixpkgs.legacyPackages.${system};
        nixpkgs-overlays = {
            nixpkgs.overlays = [
                (import ./packages)
                (final: prev: {unstable = import nixpkgs-unstable {system = system;};})
            ];
        };
    in {
        nixosConfigurations = {
            thinkpad = nixpkgs.lib.nixosSystem {
                modules = [
                    nixpkgs-overlays

                    disko.nixosModules.disko
                    impermanence.nixosModules.impermanence
                    ./hosts/thinkpad/configuration.nix
                ];
                specialArgs = {inherit inputs;};
            };
        };
    };
}
