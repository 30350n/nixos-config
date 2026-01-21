{
    config,
    lib,
    pkgs,
    ...
}: {
    options.custom.steam.enable = lib.mkEnableOption "steam";

    config = lib.mkIf config.custom.steam.enable {
        programs = {
            steam = {
                enable = true;
                package = pkgs.unfree.steam;
            };
            gamemode.enable = true;
        };

        environment.systemPackages = with pkgs; [mangohud];
    };
}
