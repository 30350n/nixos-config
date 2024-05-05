{writeShellApplication}:
writeShellApplication {
    name = "configure";
    text = ''
        pushd /etc/nixos &> /dev/null
        sudo -s
        popd &> /dev/null
    '';
}
