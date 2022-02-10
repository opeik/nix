set -euo pipefail
trap 'error_handler $?' EXIT

error_handler() {
    if [ "$1" != "0" ]; then
        error "command failed with exit status $1, aborting"
    fi
}

green() {
    GREEN='\033[1;32m'
    CLEAR='\033[0m'
    printf "''${GREEN}''${1}''${CLEAR}"
}

clean_up() {
    local tmp_dir="''${TMPDIR:-/tmp}"
    echo "killed, cleaning up tmpdirs: '$tmp_dir/vscode_exts_*'" >&2
    rm --recursive --force "$tmp_dir/vscode_exts_*"
}

get_vsixpkg() {
    local owner=$(echo "$1" | cut --delimiter . --fields 1)
    local ext=$(echo "$1" | cut --delimiter . --fields 2)
    local id="$owner.$ext"

    local ext_dir=$(mktemp --directory -t vscode_exts_XXXXXXXX)
    local ext_url="https://$owner.gallery.vsassets.io/_apis/public/gallery/publisher/$owner/"
    ext_url+="extension/$ext/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
    ${curl}/bin/curl --silent --show-error --fail --request GET --output "$ext_dir/$id.zip" "$ext_url"
    local version=$(${jq}/bin/jq --raw-output '.version' <(${unzip}/bin/unzip -qc "$ext_dir/$id.zip" "extension/package.json"))
    local sha=$(nix-hash --flat --base32 --type sha256 "$ext_dir/$id.zip")

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

main() {
    trap clean_up SIGINT
    # Non-packaged vscode extensions to install.
    local exts=(
        "GitHub.vscode-pull-request-github"
        "arrterian.nix-env-selector"
        "eamodio.gitlens"
        "foxundermoon.shell-format"
        "jnoortheen.nix-ide"
        "mhutchie.git-graph"
        "monokai.theme-monokai-pro-vscode"
        "ms-azuretools.vscode-docker"
        "redhat.vscode-yaml"
        "serayuzgur.crates"
        "streetsidesoftware.code-spell-checker"
        "tamasfe.even-better-toml"
        "usernamehw.errorlens"
        "vscodevim.vim"
        "wholroyd.hcl"
    )

    printf "$(green info:) updating vscode extensions...\n"
    cd '${flakePath}'
    local exts_nix=$(printf '{\n  extensions = [\n' &&
        ${parallel}/bin/parallel --will-cite -k get_vsixpkg ::: "''${exts[@]}" &&
        printf '  ];\n}\n')
    echo "$exts_nix" >home/vscode/extensions.nix
}

export -f get_vsixpkg
main
