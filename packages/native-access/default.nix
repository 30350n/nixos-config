# minimal version of https://github.com/yusefnapora/native-access-nix/blob/b93f71/native-access.nix
{
    fetchzip,
    pkgs,
    wrapWine,
    ...
}:
wrapWine {
    name = "native-access";
    desktopName = "Native Access";
    desktopIcon = ./icon.png;
    wine = pkgs.wineWowPackages.yabridge;
    tricks = ["ucrtbase2019"];

    installScript = let
        src = fetchzip {
            url = "https://www.native-instruments.com/fileadmin/downloads/Native_Access_Installer_211108.zip";
            sha256 = "3Jq/W51IPtcV1uL/147diZXfX+I0q+dTlHna6j3Q+s0=";
        };
    in ''
        winecfg /v win10
        wine64 "${src}/Native Access 1.14.1 Setup PC.exe" || true
    '';

    script = "wine C:/Program Files/Native Instruments/Native Access/Native Access.exe";

    extraScripts = [
        rec {
            name = "native-access-install-iso";
            text = ''
                if [[ "$#" -ne 1 ]]; then
                    echo "${name} <iso-file>"
                    exit 1
                fi
                iso_file=$1

                function cleanup() {
                    if [[ -n "$loop_device" ]]; then
                        udisksctl unmount -b "$loop_device"
                        udisksctl loop-delete -b "$loop_device"
                    fi
                }
                trap cleanup EXIT

                loop_device=$(udisksctl loop-setup -f "$iso_file" | grep -Po "/dev/loop[0-9]+")
                mount_point=$(
                    udisksctl mount -t udf -o unhide -b "$loop_device" |
                        grep -Po "Mounted $loop_device at \K(.*)"
                )
                installer=$(find "$mount_point" -type f -name "*.exe" | head -n1)

                wine64 "$installer" || true
            '';
        }
    ];
}
