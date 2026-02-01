{
    config,
    lib,
    pkgs,
    ...
}: {
    options.custom.virtualisation = with lib; {
        enable = mkEnableOption "virtualisation";

        cpuVendor = mkOption {type = types.enum ["amd" "intel"];};
        cpuSupportedFlags = mkOption {
            description = "lscpu | grep -o Flags";
            type = types.listOf types.str;
            default = ["svm"];
        };

        vms = mkOption {
            type = types.attrsOf (types.submodule ({
                name,
                config,
                ...
            }: {
                options = {
                    enable = mkEnableOption "enableVM";
                    disk = mkOption {
                        type = types.str;
                        default = "${config.directory}/disk.${config.diskFormat}";
                    };
                    diskFormat = mkOption {
                        type = types.enum ["qcow2" "raw"];
                        default = "qcow2";
                    };
                    directory = mkOption {
                        type = types.str;
                        default = "/var/lib/vms/${name}";
                    };
                    guestOs = mkOption {
                        type = types.enum ["linux" "windows"];
                        default = "linux";
                    };
                    cpuCores = mkOption {
                        type = types.int;
                        default = 4;
                    };
                    ram = mkOption {
                        type = types.str;
                        default = "4G";
                    };
                    viewer = mkOption {
                        type = types.enum ["remote-viewer" "looking-glass"];
                        default = "remote-viewer";
                    };
                    sshPort = mkOption {
                        type = types.int;
                        default = 22220;
                    };
                    secureBoot = mkOption {
                        type = types.bool;
                        default = config.guestOs == "windows";
                    };
                    sleepTimeout = mkOption {
                        type = types.int;
                        default = 300;
                    };
                    user = mkOption {type = types.str;};
                    desktopItem = mkOption {type = types.nullOr types.attrs;};
                };
            }));
        };
    };

    config = let
        virtConfig = config.custom.virtualisation;
        vms = lib.filterAttrs (_: vm: vm.enable) virtConfig.vms;
        vmBoot = lib.mapAttrs (name: vmConfig:
            pkgs.callPackage ./vm-boot.nix {
                inherit name;
                inherit (vmConfig) disk diskFormat directory;
                quickemu-args = pkgs.callPackage ./quickemu-args {
                    inherit name vmConfig;
                    inherit (virtConfig) cpuVendor cpuSupportedFlags;
                };
            })
        vms;
        vmView = lib.mapAttrs (name: vmConfig:
            pkgs.callPackage ./vm-view.nix {
                inherit name;
                inherit (vmConfig) desktopItem directory viewer;
            })
        vms;
        vmService = lib.mapAttrs (name: vmConfig:
            pkgs.callPackage ./vm-service {
                inherit name;
                inherit (vmConfig) directory guestOs sleepTimeout;
                vm-boot = vmBoot.${name};
            })
        vms;
    in
        lib.mkIf virtConfig.enable {
            virtualisation.spiceUSBRedirection.enable = true;

            systemd.tmpfiles.rules =
                ["d /var/lib/vms 0755 root root - -"]
                ++ (lib.mapAttrsToList (
                    name: vmConfig: "d /var/lib/vms/${name} 0700 ${vmConfig.user} users - -"
                )
                vms);

            nixos-core.impermanence.persist.directories = ["/var/lib/vms"];

            users.users = builtins.foldl' (
                accumulator: values:
                    accumulator
                    // {
                        ${values.vmConfig.user}.packages =
                            (accumulator.${values.vmConfig.user}.packages or [])
                            ++ [vmBoot.${values.name} vmView.${values.name}];
                    }
            ) {} (lib.mapAttrsToList (name: vmConfig: {inherit name vmConfig;}) vms);

            systemd.services = lib.mapAttrs' (name: vmConfig:
                lib.nameValuePair "vm-${name}" {
                    enable = true;
                    wantedBy = ["multi-user.target"];
                    script = "exec ${vmService.${name}}/bin/vm-${name}-service";
                    serviceConfig = {
                        User = vmConfig.user;
                        Group = "users";
                    };
                })
            vms;
        };
}
