{
    name,
    directory,
    guestOs,
    sleepTimeout,
    vm-boot,
    #
    python3,
    writeShellApplication,
}:
writeShellApplication {
    name = "vm-${name}-service";
    runtimeInputs = [python3];
    text = ''
        exec python3 -u ${./vm-service.py} \
            ${vm-boot}/bin/.vm-${name}-boot \
            ${directory} \
            ${guestOs} \
            --timeout ${toString sleepTimeout}
    '';
}
