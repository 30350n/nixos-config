help="\
Usage: $(basename "${BASH_SOURCE[0]}") [OPTIONS]

Options:
  -e, --exclude Exclude the created files from version control.
  -h, --help    Show this message and exit.
"

warning() {
    echo -e "\033[93m$1\033[0m"
}
error() {
    echo -e "\033[91m$1\033[0m"
}

exclude=false

while [[ $OPTIND -le $# ]]; do
    if getopts ":-:" OPTCHAR; then
        if [[ $OPTCHAR == "-" ]]; then
            case "$OPTARG" in
                exclude)
                    exclude=true
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
                e)
                    exclude=true
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

shell_file="shell.nix"
if [[ -f $shell_file ]]; then
    error "error: file '$shell_file' already exists"
    exit 1
fi
cat > $shell_file << EOF
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
    nativeBuildInputs = with pkgs.buildPackages; [];
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; []);
}
EOF

envrc_file=".envrc"
echo "use nix" >> "$envrc_file"
echo "export PATH=\"$(dirname "$(realpath "$(which bash)")"):\$PATH\"" >> "$envrc_file"

if $exclude; then
    repo_base=$(git rev-parse --show-toplevel 2> /dev/null || true)
    if [[ $repo_base != "" ]]; then
        relative_pwd=$(realpath -s --relative-to="$repo_base" "$(pwd)")
        exclude_file="$repo_base/.git/info/exclude"
        prefix=$([[ $relative_pwd != "." ]] && echo "$relative_pwd/" || echo "")
        echo "$prefix$envrc_file" >> "$exclude_file"
        echo "$prefix$shell_file" >> "$exclude_file"
    else
        warning "warning: failed to exclude created files (not a git repo)"
    fi
fi

if [[ $EDITOR != "" ]]; then
    $EDITOR "$shell_file"
else
    warning "warning: failed to open editor ('\$EDITOR' is not set)"
fi

if grep -q python3 "$shell_file"; then
    echo "export VIRTUAL_ENV=.venv" >> "$envrc_file"
    echo "layout python" >> "$envrc_file"
fi

direnv allow
