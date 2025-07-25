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
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-unstable,
        home-manager,
        disko,
        impermanence,
        ...
    } @ inputs: let
        defaultModules = [
            {
                nixpkgs.overlays = [
                    (final: prev: {
                        unfree = import nixpkgs {
                            system = prev.system;
                            config.allowUnfree = true;
                        };
                        unstable =
                            import nixpkgs-unstable {system = prev.system;}
                            // {
                                unfree = import nixpkgs-unstable {
                                    system = prev.system;
                                    config.allowUnfree = true;
                                };
                            };
                    })
                    (import ./packages)
                ];
            }
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
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                users.bobbe = import ./users/bobbe/home.nix;
                                users.root = import ./users/root/home.nix;
                                useGlobalPkgs = true;
                                useUserPackages = true;
                                extraSpecialArgs = specialArgs;
                            };
                        }
                    ];
            };
        };
    };
}
