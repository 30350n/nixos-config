#!/usr/bin/env bash

info () {
    echo -e "\033[94m$1\033[0m"
}
hint () {
    echo -e "\033[2;3m$1\033[0m"
}
success () {
    echo -e "\033[92m$1\033[0m"
}
error () {
    echo -e "\033[91m$1\033[0m"
}

set -euo pipefail

pushd /etc/nixos

if [[ $(id -u) != 0 ]]; then
    error "Insufficient permissions (run this script as root)"
    popd
    exit 1
fi

if [[ $(jj status) == "The working copy is clean"* ]]; then
    info "NixOS configuration is unchanged."
    popd
    exit 0
fi

info "Autoformatting NixOS configuration ..."
pre-commit run --all-files &> /dev/null || true
pre-commit run --all-files | (grep -v "Passed" || true)

info configuration changes:
jj diff --no-pager

info "Building NixOS configuration ..."
nixos-rebuild switch --flake path:. &> rebuild.log || {
    error "Building NixOS failed with:"
    grep --color error < rebuild.log
    hint "(check /etc/nixos/rebuild.log for the full build log)"
    popd
    exit 1
}

generation_prefix="Generation "
commit_message=$(
    jj show --summary | grep -e "^    " -e "^\$" | tail -n +2 | head -n -1 | cut -c 5- |
    grep -v "^$generation_prefix" | grep -v "^(no description set)\$"
)
generation=$(nixos-rebuild list-generations | grep current | awk '{print $1,$3,$4,$5}')
echo -e "$commit_message\n\n$generation_prefix$generation" | jj describe --stdin

success "Successfully built NixOS configuration!"
popd
