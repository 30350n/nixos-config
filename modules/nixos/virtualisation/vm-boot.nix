{
    name,
    disk,
    diskFormat,
    directory,
    #
    lib,
    qemu_kvm,
    quickemu-args,
    writeShellApplication,
}:
writeShellApplication {
    name = ".vm-${name}-boot";
    runtimeInputs = [qemu_kvm];
    text = let
        OVMF_VARS = "${directory}/OVMF_VARS.fd";
        qcow2Flags = lib.optionalString (diskFormat == "qcow2") "-o lazy_refcounts=on,nocow=on";
    in ''
        if [ ! -f "${disk}" ]; then
            qemu-img create -q -f "${diskFormat}" ${qcow2Flags} ${disk} 1T
        fi

        if [ ! -f "${OVMF_VARS}" ]; then
            cp "${quickemu-args.efi-vars}" "${OVMF_VARS}"
            chmod +w "${OVMF_VARS}"
        fi

        cleanup() {
            rm -f "${directory}/agent.sock"
            rm -f "${directory}/monitor.sock"
            rm -f "${directory}/spice.sock"
        }
        trap cleanup EXIT

        mapfile -t QUICKEMU_ARGS < <(sed 's/\\$//' "${quickemu-args}")

        # shellcheck disable=SC2068
        qemu-system-x86_64 \
            ''${QUICKEMU_ARGS[@]} \
            "$@"
    '';
}
