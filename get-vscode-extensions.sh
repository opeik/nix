#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq unzip parallel
# shellcheck shell=bash
set -eu -o pipefail

ARGS="$@"

# Helper to just fail with a message and non-zero exit code.
function fail() {
    echo "$1" >&2
    exit 1
}

# Helper to clean up after ourselves if we're killed by SIGINT.
function clean_up() {
    TDIR="${TMPDIR:-/tmp}"
    echo "Script killed, cleaning up tmpdirs: $TDIR/vscode_exts_*" >&2
    rm -Rf "$TDIR/vscode_exts_*"
}

function contains() {
    local e match="$1"
    shift
    for e; do echo "$e" "$match"; done
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}

function get_vsixpkg() {
    local owner=$(echo "$1" | cut -d. -f1)
    local ext=$(echo "$1" | cut -d. -f2)
    local n="$owner.$ext"
    local args="${@:2}"

    for arg in $args; do
        if [ "$n" = "$arg" ]; then
            exit
        fi
    done

    # Create a tempdir for the extension download.
    EXTTMP=$(mktemp -d -t vscode_exts_XXXXXXXX)

    URL="https://$owner.gallery.vsassets.io/_apis/public/gallery/publisher/$owner/extension/$ext/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

    # Quietly but delicately curl down the file, blowing up at the first sign of trouble.
    curl --silent --show-error --fail -X GET -o "$EXTTMP/$n.zip" "$URL"
    # Unpack the file we need to stdout then pull out the version
    VER=$(jq -r '.version' <(unzip -qc "$EXTTMP/$n.zip" "extension/package.json"))
    # Calculate the SHA
    SHA=$(nix-hash --flat --base32 --type sha256 "$EXTTMP/$n.zip")

    # Clean up.
    rm -Rf "$EXTTMP"
    # I don't like 'rm -Rf' lurking in my scripts but this seems appropriate.

    cat <<-EOF
    {
      name = "$ext";
      publisher = "$owner";
      version = "$VER";
      sha256 = "$SHA";
    }
EOF
}

export -f contains get_vsixpkg

# Try to be a good citizen and clean up after ourselves if we're killed.
trap clean_up SIGINT

# Note that we are only looking to update extensions that are already installed.
printf '{\n  extensions = [\n'
#parallel -k -j16 get_vsixpkg ::: $(code --list-extensions)
parallel -k -j16 get_vsixpkg ::: $(code --list-extensions) ::: "$ARGS"
printf '  ];\n}\n'
