{
    name,
    disk,
    diskFormat,
    directory,
    viewer,
    passthrough,
    ivshmem,
    #
    lib,
    libvirt,
    qemu_kvm,
    quickemu-args,
    writeShellApplication,
}:
writeShellApplication {
    name = ".vm-${name}-boot";
    runtimeInputs = [libvirt qemu_kvm];
    text = let
        indent = string: lib.replaceString "\n" "\n    " string;
        OVMF_VARS = "${directory}/OVMF_VARS.fd";
        qcow2Flags = lib.optionalString (diskFormat == "qcow2") "-o lazy_refcounts=on,nocow=on";
        virshIds =
            map (id: "pci_${lib.replaceStrings [":" "."] ["_" "_"] id}")
            (builtins.concatLists (map (device: device.pcieDevices) passthrough));
        detachPcieDevices = lib.concatLines (
            map (id: "virsh -c qemu:///system nodedev-detach ${id}") virshIds
        );
        reattachPcieDevices = lib.concatLines (
            map (id: "virsh -c qemu:///system nodedev-reattach ${id}") virshIds
        );
        qemuPcieFlags = lib.concatLines (
            ["-device pcie-root-port,id=pcie.1,bus=pcie.0,slot=1,chassis=1 \\"]
            ++ builtins.concatLists (
                map (device:
                    lib.imap0 (
                        i: shortId:
                            "-device vfio-pci,host=${shortId},bus=pcie.1,addr=00.${toString i}"
                            + lib.optionalString (
                                i == 0 && (builtins.length device.pcieDevices) > 1
                            ) ",multifunction=on"
                            + lib.optionalString (
                                i == 0 && device.romfile != null
                            ) ",romfile=${device.romfile}"
                            + " \\"
                    )
                    (map (id: builtins.substring 5 99 id) device.pcieDevices))
                passthrough
            )
        );
        useLookingGlass = viewer == "looking-glass";
        qemuLookingGlassFlags = let
            size = "size=${assert ivshmem != null; toString ivshmem}M";
        in ''
            -device ivshmem-plain,id=shmem0,memdev=looking-glass \
            -object memory-backend-file,id=looking-glass,mem-path=/dev/kvmfr0,${size},share=yes \
        '';
    in ''
        if [ ! -f "${disk}" ]; then
            qemu-img create -q -f "${diskFormat}" ${qcow2Flags} ${disk} 1T
        fi

        if [ ! -f "${OVMF_VARS}" ]; then
            cp "${quickemu-args.efi-vars}" "${OVMF_VARS}"
            chmod +w "${OVMF_VARS}"
        fi

        cleanup() {
            ${indent reattachPcieDevices}
            rm -f "${directory}/agent.sock"
            rm -f "${directory}/monitor.sock"
            rm -f "${directory}/spice.sock"
        }
        trap cleanup EXIT

        ${detachPcieDevices}

        mapfile -t QUICKEMU_ARGS < <(sed 's/\\$//' "${quickemu-args}")

        # shellcheck disable=SC2068
        qemu-system-x86_64 \
            ''${QUICKEMU_ARGS[@]} \
            ${indent (lib.optionalString (passthrough != []) qemuPcieFlags)}\
            ${indent (lib.optionalString useLookingGlass qemuLookingGlassFlags)}\
            "$@"
    '';
}
