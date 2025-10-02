{devices ? import ./devices.nix, ...}: {
    disko.devices = {
        disk.main = {
            device = devices.main;
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    ESP = {
                        type = "EF00";
                        size = "1G";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = ["umask=0077"];
                        };
                    };
                    SWAP = {
                        type = "8200";
                        size = "16G";
                        content = {
                            type = "swap";
                        };
                    };
                    ZFS = {
                        type = "8300";
                        size = "100%";
                        content = {
                            type = "zfs";
                            pool = "zroot";
                        };
                    };
                };
            };
        };

        zpool = {
            zroot = {
                type = "zpool";
                options = {
                    ashift = "12";
                    autotrim = "on";
                };
                rootFsOptions = {
                    canmount = "off";
                    dnodesize = "legacy";
                    normalization = "formD";
                    relatime = "on";

                    acltype = "posixacl";
                    xattr = "sa";
                };

                datasets = {
                    root = {
                        type = "zfs_fs";
                        options.mountpoint = "legacy";
                        mountpoint = "/";
                        postCreateHook = "zfs snapshot zroot/root@blank";
                    };
                    nix = {
                        type = "zfs_fs";
                        options.mountpoint = "legacy";
                        mountpoint = "/nix";
                    };
                    home = {
                        type = "zfs_fs";
                        options.mountpoint = "legacy";
                        mountpoint = "/home";
                    };
                    persist = {
                        type = "zfs_fs";
                        options.mountpoint = "legacy";
                        mountpoint = "/persist";
                    };
                };
            };
        };
    };
}
