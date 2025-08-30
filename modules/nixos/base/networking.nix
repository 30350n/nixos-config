{
    networking = {
        networkmanager.enable = true;
        enableIPv6 = false;
    };

    services.avahi = {
        enable = true;
        nssmdns4 = true;
    };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Enable CUPS to print documents.
    # services.printing.enable = true;
}
