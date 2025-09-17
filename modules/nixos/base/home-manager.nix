{hostName, ...}: {
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit hostName;};
    };
}
