set -euo pipefail
trap 'error_handler $?' EXIT
host="''${1-$(hostname)}"

error_handler() {
    if [ "$1" != "0" ]; then
        error "command failed with exit status $1, aborting"
    fi
}

# Prints the specified string in green.
green() {
    GREEN='\033[1;32m'
    CLEAR='\033[0m'
    printf "''${GREEN}''${1}''${CLEAR}"
}

main() {
    local current_dir="$PWD"
    cd '${flakePath}'
    printf "$(green info:) updating git repository...\n"
    ${git}/bin/git add .
    ${git}/bin/git pull --quiet

    printf "$(green info:) switching host \`''${host}\`...\n"
    case "$OSTYPE" in
    "darwin"*)
        darwin-rebuild switch --flake ".#''${host}"
        ;;
    "linux-gnu"*)
        sudo nixos-rebuild switch --flake ".#''${host}"
        ;;
    *)
        printf "unsupported os"
        exit 1
        ;;
    esac
}

main
