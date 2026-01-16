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
            drawing
            firefox
            file-roller
            gnome-disk-utility
            (krusader.overrideAttrs (finalAttrs: prevAttrs: {
                nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [kdePackages.kate];
            }))
            lact
            loupe
            localsend
            mission-center
            papers
            simple-scan
            ungoogled-chromium
            thunderbird
            vlc

            (python3.withPackages (pythonPackages: [
                pythonPackages.numpy
            ]))
        ];

        nixos-core.impermanence.persist.directories = [
            "/root/.cache/pre-commit"
            "/root/.config/VSCodium"
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
                monospace = ["BlexMono Nerd Font" "IBM Plex Mono"];
            };
        };

        hardware.bluetooth.enable = lib.mkOverride 999 config.custom.isLaptop;

        networking = {
            networkmanager.enable = true;
            inherit hostName;
            # pip doesn't work with ipv6 (https://github.com/pypi/warehouse/issues/15277)
            enableIPv6 = false;
        };

        services = {
            openssh.enable = true;
            printing = {
                enable = true;
                drivers = with pkgs; [
                    unfree.cnijfilter2
                    ptouch-driver
                ];
            };
        };

        systemd.packages = with pkgs; [lact];
        systemd.services.lactd.wantedBy = ["multi-user.target"];

        users.mutableUsers = false;
        nixos-core.normalUserGroups = ["networkmanager" "wheel"];
        users.users.root.hashedPasswordFile = "/persist/passwords/root";
        home-manager.users.root = ../../users/root/home.nix;

        system.stateVersion = "23.11";
    };
}
