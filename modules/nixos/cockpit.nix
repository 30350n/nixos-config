{
    config,
    pkgs,
    ...
}: {
    services.cockpit = {
        enable = true;
        allowed-origins = ["http://localhost:${builtins.toString config.services.cockpit.port}"];
    };

    environment.systemPackages = [
        (pkgs.nixos-core.makeWebApp {
            url = "localhost:9090";
            name = "Cockpit";
            icon = "${pkgs.cockpit.src}/pkg/shell/images/cockpit-icon.svg";
        })
    ];
}
