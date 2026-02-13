{
    name,
    desktopItem,
    directory,
    viewer,
    #
    inotify-tools,
    lib,
    looking-glass-client,
    makeDesktopItem,
    symlinkJoin,
    virt-viewer,
    writeShellApplication,
}: let
    vm-view-name = "vm-${name}-view";
    vm-view = writeShellApplication {
        name = vm-view-name;
        runtimeInputs =
            [inotify-tools]
            ++ (lib.optional (viewer == "remote-viewer") virt-viewer)
            ++ (lib.optional (viewer == "looking-glass") looking-glass-client);
        text = let
            socket = "${directory}/spice.sock";
        in
            ''
                if [ ! -f "${directory}/.pid" ]; then
                    rm -f "${socket}"
                    systemctl kill -s SIGUSR1 vm-${name}
                    if ! inotifywait -t 5 -e create --include "spice.sock" "${directory}"; then
                        exit 1
                    fi
                fi
            ''
            + (
                if viewer == "remote-viewer"
                then ''
                    remote-viewer -f spice+unix://${socket}
                ''
                else if viewer == "looking-glass"
                then ''
                    looking-glass-client -f /dev/kvmfr0 -F -c ${socket} -p ""
                ''
                else assert false; null
            );
    };
in
    if desktopItem == null
    then vm-view
    else
        symlinkJoin {
            name = vm-view-name;
            paths = [
                vm-view
                (makeDesktopItem (
                    desktopItem
                    // {
                        name = vm-view-name;
                        exec = "${vm-view}/bin/${vm-view-name}";
                    }
                ))
            ];
        }
