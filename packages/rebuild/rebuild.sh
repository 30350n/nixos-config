#!/usr/bin/env bash

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

set -euo pipefail

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

if [[ $(jj status) == "The working copy is clean"* ]]; then
    info "NixOS configuration is unchanged."
    popd &> /dev/null
    exit 0
fi

if $update; then
    info "Updating NixOS configuration ..."
    nix flake update
fi

info "Autoformatting NixOS configuration ..."
pre-commit run --all-files &> /dev/null || true
pre-commit run --all-files | (grep -v "Passed" || true)

info configuration changes:
jj diff --no-pager

info "Building NixOS configuration ..."
nixos-rebuild switch --flake path:. |& tee rebuild.log |& nom || {
    error "Building NixOS failed with:"
    grep --color error < rebuild.log || error "unknown error"
    hint "(check /etc/nixos/rebuild.log for the full build log)"
    popd &> /dev/null
    exit 1
}

list_generations_fix=$(
    nixos-rebuild list-generations --json | jq -r '.[] | [
        .generation, 0, (.date | fromdate | strflocaltime("%Y-%m-%d %H:%M:%S")),
        .nixosVersion, .kernelVersion
    ] | @tsv'
)

generation_prefix="Generation "
commit_message=$(
    jj show --summary | grep -e "^    " -e '^$' | tail -n +2 | head -n -1 | cut -c 5- |
        grep -v "^$generation_prefix" | grep -v '^(no description set)$' || true
)
generation=$(echo "$list_generations_fix" | head -n 1 | awk '{print $1,$3,$4,$5}' || true)
echo -e "$commit_message\n\n$generation_prefix$generation" | jj describe --stdin &> /dev/null

success "Successfully built NixOS configuration!"
hint "($generation_prefix$generation)"
popd &> /dev/null
