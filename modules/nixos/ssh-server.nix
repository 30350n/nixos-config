{
    services.openssh.enable = true;

    services.avahi = {
        publish = {
            enable = true;
            addresses = true;
            domain = true;
            hinfo = true;
            workstation = true;
        };
    };
}
