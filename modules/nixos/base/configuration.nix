{
    imports = [
        ./boot.nix
        ./fish.nix
        ./impermanence.nix
        ./locale.nix
        ./packages.nix
    ];

    networking.networkmanager.enable = true;
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    users.mutableUsers = false;
    users.users.root.hashedPasswordFile = "/persist/passwords/root";

    security.sudo.extraConfig = ''
        Defaults lecture = never
        Defaults env_keep += "EDITOR"
    '';

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "23.11";
}
