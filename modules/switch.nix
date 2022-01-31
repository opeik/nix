{ pkgs, ... }:
let
  # Script to quickly update the system configuration.
  flakePath = if pkgs.stdenv.isDarwin then "/Users/opeik/dev/nix" else "/home/opeik/dev/nix";
  nix-switch = with pkgs; pkgs.writeShellScriptBin "nix-switch" ''
    #! /usr/bin/env nix-shell
    set -euo pipefail

    host="''${1-$(hostname)}"

    # Prints the specified string in green.
    green() {
        GREEN='\033[1;32m'
        CLEAR='\033[0m'
        printf "''${GREEN}''${1}''${CLEAR}"
    }

    main() {
        cd '${flakePath}'
        printf "$(green info:) updating git repository...\n"
        ${git}/bin/git pull --quiet

        printf "$(green info:) updating vscode extensions...\n"
        local exts="$(${vscode-update-exts}/bin/vscode-update-exts vadimcn.vscode-lldb matklad.rust-analyzer)"
        echo "$exts" > home/vscode/extensions.nix

        printf "$(green info:) switching host \`''${host}\`...\n"
        case "$OSTYPE" in
        "darwin"*)
            sudo darwin-rebuild switch --flake ".#''${host}"
            ;;
        "linux-gnu"*)
            sudo nixos-rebuild switch --flake ".#''${host}"
            ;;
        *)
            printf "unsupported os"
            exit 1
            ;;
        esac

        printf "$(green info:) switch ok!\n"
    }

    main
  '';

  vscode-update-exts = with pkgs; writeShellScriptBin "vscode-update-exts" ''
    set -eu -o pipefail

    # Helper to just fail with a message and non-zero exit code.
    function fail() {
        echo "$1" >&2
        exit 1
    }

    # Helper to clean up after ourselves if we're killed by SIGINT.
    function clean_up() {
        local tmp_dir="''${TMPDIR:-/tmp}"
        echo "killed, cleaning up tmpdirs: '$tmp_dir/vscode_exts_*'" >&2
        rm --recursive --force "$tmp_dir/vscode_exts_*"
    }

    # Prints the corresponding Nix code for the latest version of a vsixpkg.
    function get_vsixpkg() {
        local owner=$(echo "$1" | cut --delimiter . --fields 1)
        local ext=$(echo "$1" | cut --delimiter . --fields 2)
        local id="$owner.$ext"
        local exts_to_skip="''${@:2}"

        # Skip extensions matching an argument.
        for i in $exts_to_skip; do
            if [ "$id" = "$i" ]; then
                exit
            fi
        done

        # Create a tempdir for the extension download.
        local ext_dir=$(mktemp --directory -t vscode_exts_XXXXXXXX)
        local ext_url="https://$owner.gallery.vsassets.io/_apis/public/gallery/publisher/$owner/"
        ext_url+="extension/$ext/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

        # Quietly but delicately curl down the file, blowing up at the first sign of trouble.
        ${curl}/bin/curl --silent --show-error --fail --request GET --output "$ext_dir/$id.zip" "$ext_url"
        # Unpack the file we need to stdout then pull out the version
        local version=$(${jq}/bin/jq --raw-output '.version' <(${unzip}/bin/unzip -qc "$ext_dir/$id.zip" "extension/package.json"))
        # Calculate the sha
        local sha=$(nix-hash --flat --base32 --type sha256 "$ext_dir/$id.zip")

        # Clean up. I don't like 'rm -Rf' lurking in my scripts but this seems appropriate.
        rm --recursive --force "$ext_dir"

        cat <<-EOF
        {
            name = "$ext";
            publisher = "$owner";
            version = "$version";
            sha256 = "$sha";
        }
    EOF
    }

    function main() {
        # Try to be a good citizen and clean up after ourselves if we're killed.
        trap clean_up SIGINT

        printf '{\n  extensions = [\n'
        ${parallel}/bin/parallel -k get_vsixpkg ::: $(${coreutils}/bin/ls -1 -v ~/.vscode/extensions) ::: "$ARGS"
        printf '  ];\n}\n'
    }

    export -f get_vsixpkg
    ARGS="$@"
    main
  '';
in
{
  environment.systemPackages = [ nix-switch ];
}
