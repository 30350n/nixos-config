{pkgs, ...}: {
    imports = [
        ./boot.nix
        ./impermanence.nix
    ];

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
        layout = "de";
        variant = "nodeadkeys";
        options = "eurosign:e";
    };
    console.useXkbConfig = true;

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
        Defaults env_keep += "EDITOR"
        Defaults lecture = never
    '';

    environment.systemPackages = with pkgs; [
        git
        unstable.jujutsu
        custom.configure
        custom.rebuild

        firefox
        alacritty
    ];

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "23.11";
}
