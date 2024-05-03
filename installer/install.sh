#!/bin/sh

repo_url="https://github.com/30350n/nixos-config"
raw_repo_url="https://raw.githubusercontent.com/30350n/nixos-config/master"

shell_commands="
    python -m venv ./venv
    source ./venv/bin/activate
    pip install -q $(curl -fsSL $raw_repo_url/installer/requirements.txt | tr '\n' ' ')
    python -c '$(curl -fsSL $raw_repo_url/installer/install.py)' $repo_url
"

sudo nix-shell --quiet --packages python3 python3Packages.gitpython --run "$shell_commands"
