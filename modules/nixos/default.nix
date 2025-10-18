{
    config,
    hostName,
    lib,
    pkgs,
    ...
}: {
    imports = lib.nixos-core.autoImport ./.;

    options.custom = {
        isLaptop = lib.mkEnableOption "isLaptop";
    };

    config = {
        environment.systemPackages = with pkgs; [
            custom.configure-codium

            alacritty
            baobab
            eyedropper
            firefox
            file-roller
            krusader
            loupe
            localsend
            papers
            scrcpy
            simple-scan
            vlc

            (python3.withPackages (pythonPackages: [
                pythonPackages.numpy
                pythonPackages.bpython
            ]))
        ];

        fonts = {
            packages = with pkgs; [
                custom.ibm-plex
                custom.nerd-fonts.blex-mono
                custom.segoe-ui
            ];

            fontconfig.defaultFonts = {
                serif = ["IBM Plex Serif"];
                sansSerif = ["Segoe UI"];
                monospace = ["IBM Plex Mono" "BlexMono Nerd Font"];
            };
        };

        hardware.bluetooth.enable = lib.mkOverride 999 config.custom.isLaptop;

        networking = {
            networkmanager.enable = true;
            inherit hostName;
            enableIPv6 = false;
        };

        services = {
            openssh.enable = true;
            printing.enable = true;
        };

        users.mutableUsers = false;
        users.users.root.hashedPasswordFile = "/persist/passwords/root";
        home-manager.users.root = ../../users/root/home.nix;

        system.stateVersion = "23.11";
    };
}
