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
        ivshmem = mkOption {type = types.nullOr (types.enum [32 64 128 256]);};

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
                    passthrough = mkOption {
                        type = types.listOf (types.submodule {
                            options = {
                                pcieDevices = mkOption {type = types.listOf types.str;};
                                romfile = mkOption {
                                    type = types.nullOr (types.oneOf [types.path types.str]);
                                };
                            };
                        });
                        default = [];
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
        usePciePassthrough =
            builtins.any (vm: vm.passthrough != []) (builtins.attrValues vms);
        vmBoot = lib.mapAttrs (name: vmConfig:
            pkgs.callPackage ./vm-boot.nix {
                inherit name;
                inherit (vmConfig) disk diskFormat directory viewer passthrough;
                inherit (virtConfig) ivshmem;
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
        lib.mkIf virtConfig.enable (lib.mkMerge [
            {
                environment.systemPackages = [(pkgs.callPackage ./lsiommu.nix {})];

                virtualisation.spiceUSBRedirection.enable = true;

                systemd.tmpfiles.rules =
                    ["d /var/lib/vms 0755 root root - -"]
                    ++ (lib.mapAttrsToList (
                        name: vmConfig: "d /var/lib/vms/${name} 0770 vm-${name} vm-${name} - -"
                    )
                    vms);

                nixos-core.impermanence.persist.directories = ["/var/lib/vms"];

                users.users =
                    (lib.mapAttrs' (
                        name: vmConfig:
                            lib.nameValuePair "vm-${name}" {
                                isSystemUser = true;
                                group = "vm-${name}";
                                home = vmConfig.directory;
                            }
                    )
                    vms)
                    // (builtins.foldl' (
                        accumulator: values:
                            accumulator
                            // {
                                ${values.vmConfig.user}.packages =
                                    (accumulator.${values.vmConfig.user}.packages or [])
                                    ++ [vmBoot.${values.name} vmView.${values.name}];
                            }
                    ) {} (lib.mapAttrsToList (name: vmConfig: {inherit name vmConfig;}) vms));

                users.groups = lib.mapAttrs' (
                    name: vmConfig: lib.nameValuePair "vm-${name}" {members = [vmConfig.user];}
                )
                vms;

                systemd.services = lib.mapAttrs' (name: vmConfig:
                    lib.nameValuePair "vm-${name}" {
                        enable = true;
                        wantedBy = ["multi-user.target"];
                        script = "exec ${vmService.${name}}/bin/vm-${name}-service";
                        serviceConfig = {
                            User = "vm-${name}";
                            Group = "vm-${name}";
                            UMask = "0002";
                            KillMode = "mixed";
                        };
                    })
                vms;

                security.polkit.extraConfig = lib.concatLines (lib.mapAttrsToList (
                    name: vmConfig: ''
                        polkit.addRule(function(action, subject) {
                          if (action.id == "org.freedesktop.systemd1.manage-units" &&
                              subject.user == "${vmConfig.user}" &&
                              action.lookup("unit") == "vm-${name}.service") {
                            return polkit.Result.YES;
                          }
                        });
                    ''
                )
                vms);
            }
            (lib.mkIf usePciePassthrough {
                boot.kernelParams = [
                    "${virtConfig.cpuVendor}_iommu=on"
                    "iommu=pt"
                    "kvm.ignore_msrs=1"
                ];
                boot.initrd.kernelModules = ["vfio" "vfio_pci" "vfio_iommu_type1"];
                virtualisation.libvirtd.enable = true;

                users.groups.libvirtd.members = lib.unique (builtins.concatLists (
                    lib.mapAttrsToList (
                        name: vmConfig:
                            lib.optionals (vmConfig.passthrough != []) [
                                "vm-${name}"
                                vmConfig.user
                            ]
                    )
                    vms
                ));

                security.pam.loginLimits = [
                    {
                        domain = "@libvirtd";
                        type = "-";
                        item = "memlock";
                        value = "unlimited";
                    }
                ];

                systemd.services = lib.mapAttrs' (
                    name: vmConfig:
                        lib.nameValuePair "vm-${name}" {serviceConfig.LimitMEMLOCK = "infinity";}
                )
                vms;

                services.udev.extraRules = ''
                    SUBSYSTEM=="vfio", OWNER="root", GROUP="libvirtd"
                '';
            })
            (lib.mkIf (virtConfig.ivshmem != null) {
                boot.extraModulePackages = [config.boot.kernelPackages.kvmfr];
                boot.initrd.kernelModules = ["kvmfr"];
                boot.kernelParams = ["kvmfr.static_size_mb=${toString virtConfig.ivshmem}"];

                services.udev.packages = [
                    (pkgs.writeTextFile {
                        name = "kvmfr";
                        text = ''
                            SUBSYSTEM=="kvmfr", GROUP="libvirtd", MODE="0660", TAG+="uaccess"
                        '';
                        destination = "/etc/udev/rules.d/70-kvmfr.rules";
                    })
                ];
            })
        ]);
}
