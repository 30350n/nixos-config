#! /bin/bash

help() {
    printf "Set commit timestamp to author timestamp\n\n"
    printf "\\033[1;33mUsage:\\033[1;32m jj commit-time-to-author\\033[0;32m [REVISION]\\033[0m\n\n"
    printf "\\033[1;33mArguments:\\033[0m\n"
    printf "  \\033[32m[REVISION]\\033[0m\n"
    printf "          The revision whose commit timestamp should be adjusted (default: @)\n"
}

if [ "$#" -eq 0 ]; then
    REVISION="@"
elif [ "$#" -eq 1 ] && [ "$1" != "--help" ] && [ "$1" != "help" ]; then
    REVISION="$1"
else
    help
    exit
fi

# use jj show to check if REVISION resolved to more than one revision
jj show "$REVISION" > /dev/null 2>&1 || jj show "$REVISION" || exit 0

JJ_NAME="$(
    jj log --template "author.name()" -r "$REVISION" | head -n 1 | sed -E 's/^\S*\s+(\S*)/\1/'
)"
JJ_EMAIL="$(
    jj log --template "author.email()" -r "$REVISION" | head -n 1 | sed -E 's/^\S*\s+(\S*)/\1/'
)"
JJ_TIMESTAMP="$(
    jj log --template "author.timestamp()" -r "$REVISION" | head -n 1 |
        sed -E 's/^\S*\s+(\S*)\s+(\S*)\s+(\S*)/\1T\2\3/'
)"

echo "setting commit timestamp to: $JJ_TIMESTAMP"
(
    export JJ_NAME
    export JJ_EMAIL
    export JJ_TIMESTAMP
    jj describe --reset-author --no-edit --quiet "$REVISION"
)
