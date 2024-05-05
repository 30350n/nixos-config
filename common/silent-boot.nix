{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: let
    useHostResolvConf = config.networking.resolvconf.enable && config.networking.useHostResolvConf;
in {
    config = {
        boot = {
            consoleLogLevel = 0;
            initrd.verbose = false;
            kernelParams = ["quiet" "log_level=3" "systemd.show_status=false" "rd.udev.log_level=3"];
        };

        # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/system/boot/stage-2.nix
        system.build.bootStage2 = lib.mkForce (pkgs.substituteAll {
            src = pkgs.runCommand "stage-2-init.sh" {} ''
                sed 's/echo/:/' ${inputs.nixpkgs}/nixos/modules/system/boot/stage-2-init.sh > $out
            '';
            shellDebug = "${pkgs.bashInteractive}/bin/bash";
            shell = "${pkgs.bash}/bin/bash";
            inherit (config.boot) readOnlyNixStore systemdExecutable extraSystemdUnitPaths;
            inherit (config.system.nixos) distroName;
            isExecutable = true;
            inherit useHostResolvConf;
            inherit (config.system.build) earlyMountScript;
            path = lib.makeBinPath ([
                pkgs.coreutils
                pkgs.util-linux
            ]
            ++ lib.optional useHostResolvConf pkgs.openresolv);
            postBootCommands = pkgs.writeText "local-cmds"
            ''
                ${config.boot.postBootCommands}
                ${config.powerManagement.powerUpCommands}
            '';
        });
    };
}
