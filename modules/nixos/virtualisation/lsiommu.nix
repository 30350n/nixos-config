# from https://github.com/bryansteiner/gpu-passthrough-tutorial
{
    pkgs,
    writeShellApplication,
}:
writeShellApplication {
    name = "lsiommu";
    runtimeInputs = with pkgs; [pciutils];
    text = ''
        for d in /sys/kernel/iommu_groups/*/devices/*; do
            n=''${d#*/iommu_groups/*}; n=''${n%%/*}
            printf "IOMMU Group %s " "$n"
            lspci -nns "''${d##*/}"
        done
    '';
}
