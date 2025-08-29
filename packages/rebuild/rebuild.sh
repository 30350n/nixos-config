help="\
Usage: $(basename "${BASH_SOURCE[0]}") [OPTIONS]

Options:
  -u, --update Update the flake before rebuilding.
  -h, --help   Show this message and exit.
"

info() {
    echo -e "\033[94m$1\033[0m"
}
hint() {
    echo -e "\033[2;3m$1\033[0m"
}
success() {
    echo -e "\033[92m$1\033[0m"
}
warning() {
    echo -e "\033[93m$1\033[0m"
}
error() {
    echo -e "\033[91m$1\033[0m"
}

unexpected_error() {
    error "Unexpected error on line $1 (code $2)"
}
trap 'unexpected_error $LINENO $?' ERR

update=false

while [[ $OPTIND -le $# ]]; do
    if getopts ":-:" OPTCHAR; then
        if [[ $OPTCHAR == "-" ]]; then
            case "$OPTARG" in
                update)
                    update=true
                    ;;
                help)
                    echo "$help"
                    exit 0
                    ;;
                *)
                    warning "warning: invalid argument '--$OPTARG'"
                    ;;
            esac
        else
            case "$OPTARG" in
                u)
                    update=true
                    ;;
                h)
                    echo "$help"
                    exit 0
                    ;;
                *)
                    warning "warning: invalid argument '-$OPTARG'"
                    ;;
            esac
        fi
    fi
done

pushd /etc/nixos &> /dev/null

if [[ $(id -u) != 0 ]]; then
    popd &> /dev/null
    sudo rebuild || exit $?
    exit 0
fi

if $update; then
    info "Updating NixOS configuration ..."
    nix flake update
fi

info "Autoformatting NixOS configuration ..."
pre-commit run --all-files &> /dev/null || true
pre-commit run --all-files | (grep -v "Passed" || true)

echo
info "Configuration changes:"
changed_files=$(jj diff --summary --color always)
if [[ $(wc -l <<< "$changed_files") -le 5 ]]; then
    jj diff --no-pager
else
    echo "$changed_files"
fi

echo
info "Building NixOS configuration ..."
nixos-rebuild switch --flake path:. --log-format internal-json -v |&
    tee >(
        awk '
            BEGIN { cmd = "jq --unbuffered --raw-output '\''select(.action == \"msg\").msg'\''" }
            /^@nix / {
                gsub(/^@nix /, "")
                print | cmd
                next
            }
            {
                gsub(/\x1b\[[0-9;]*m/, "")
                print
            }
            END { close(cmd) }
        ' > rebuild.log
    ) |&
    nom --json ||
    {
        hint "(check /etc/nixos/rebuild.log for the full build log)"
        popd &> /dev/null
        exit 1
    }

NIX_SYSTEM="/nix/var/nix/profiles/system"
generation_number=$(readlink "$NIX_SYSTEM" | awk -F "-" '{print $2}')
generation_date=$(
    stat --format %W "$(readlink -f $NIX_SYSTEM)" | jq -r 'strflocaltime("%Y-%m-%d %H:%M:%S")'
)
generation_nixos_version=$(cat $NIX_SYSTEM/nixos-version)

generation_prefix="Generation "
commit_message=$(
    jj show --summary | grep -e "^    " -e '^$' | tail -n +2 | head -n -1 | cut -c 5- |
        grep -v "^$generation_prefix" | grep -v '^(no description set)$' || true
)
generation="$generation_number $generation_date $generation_nixos_version"
echo -e "$commit_message\n\n$generation_prefix$generation" | jj describe --stdin --quiet

success "Successfully built NixOS configuration!"
hint "($generation_prefix$generation)"
popd &> /dev/null
