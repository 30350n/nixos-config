# modified version of https://github.com/lucasew/nixcfg/blob/ebcac9/nix/pkgs/wrapWine.nix
{pkgs, ...}: {
    name,
    executable,
    is64bit ? false,
    wine ?
        if is64bit
        then pkgs.wineWow64Packages.stable
        else pkgs.wineWowPackages.stable,
    wineFlags ? "",
    tricks ? [],
    installScript ? "",
    desktopName ? null,
    desktopIcon ? null,
    extraScripts ? [],
}: let
    wineNix = "$XDG_STATE_HOME/wine-nix";
    wineBin = "${wine}/bin/wine${
        if is64bit
        then "64"
        else ""
    }";
    wineArch =
        if is64bit
        then "win64"
        else "win32";
    wineNixInit = ''
        export WINEARCH=${wineArch}
        export WINEPREFIX="${wineNix}/${name}"
        export WINEDLLOVERRIDES=winemenubuilder.exe=d

        mkdir -p "${wineNix}"
    '';
    tricksHook =
        if (builtins.length tricks) == 0
        then ""
        else "${pkgs.winetricks}/bin/winetricks --force ${builtins.concatStringsSep " " tricks}";
    application = pkgs.writeShellApplication {
        inherit name;
        runtimeInputs = [wine pkgs.samba];
        text = ''
            ${wineNixInit}
            if [ ! -d "$WINEPREFIX" ]; then
                ${wine}/bin/wineboot
                wineserver -w
                ${tricksHook}
                ${installScript}
            fi
            ${wineBin} ${wineFlags} "${executable}" "$@"
            wineserver -w
        '';
    };
    desktopItem = pkgs.makeDesktopItem {
        inherit name desktopName;
        exec = "${application}/bin/${name}";
        icon = desktopIcon;
    };
    wrapScript = script:
        pkgs.writeShellApplication {
            inherit (script) name;
            runtimeInputs = [wine pkgs.samba];
            text = ''
                ${wineNixInit}
                if [ ! -d "$WINEPREFIX" ]; then
                    echo "'$WINEPREFIX' does not exist"
                    exit 1
                fi
                ${script.text}
            '';
        };
in
    pkgs.symlinkJoin {
        name = "${name}-wrapped";
        paths =
            [application]
            ++ (map wrapScript extraScripts)
            ++ (
                if desktopName == null
                then []
                else [desktopItem]
            );
    }
