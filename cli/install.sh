#!/usr/bin/env sh
# shellcheck shell=dash
set -o nounset

main() {
    local _os _cpu _url _file _dir _err
    _os="$(uname -s)"; _cpu="$(uname -m)"; _dir="$(mktemp -d)"
    case $_os in Darwin) _os=apple-darwin; esac
    case $_cpu in arm64) _cpu=aarch64; esac
    _file="install-$_cpu-$_os.zip"
    _url="https://nightly.link/opeik/nix/workflows/ci/main/$_file"

    printf "\33[1minfo:\33[0m downloading installer\n" 1>&2
    _err="$(curl --silent --show-error --fail --remote-name --tlsv1.2 --retry 3 --proto '=https' \
         --location "$_url" --output-dir "$_dir" 2>&1)"

    if [ -n "$_err" ]; then
        if echo "$_err" | grep -q 404$; then
            echo "unsupported platform '$_cpu-$_os'"
        else
            echo "$_err"
        fi
        exit 1
    fi

    unzip -q "$_dir/$_file" -d "$_dir" && chmod u+x "$_dir/install" && "$_dir/install" "$@"
}

main "$@"
