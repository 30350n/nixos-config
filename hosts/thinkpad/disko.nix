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
                        size = "500M";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = ["umask=0077"];
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
