{ pkgs, config, ... }:
let
  path = "${config.users.users.${config.flake.user}.home}/Development/nix";

  nix-switch = with pkgs; writeShellScriptBin "nix-switch" ''
    set -euo pipefail
    trap 'error_handler $?' EXIT
    host="''${1-$(hostname)}"

    error_handler() {
      if [ "$1" != "0" ]; then
        error "command failed with exit status $1, aborting"
      fi
    }

    info() {
      local green='\033[1;32m'
      local clear='\033[0m'
      echo -e "''${green}info:''${clear} $1"
    }

    main() {
      local current_dir="$PWD"
      cd '${path}'
      info "updating git repository..."
      ${git}/bin/git add .
      ${git}/bin/git pull --quiet

      info "switching host \`$host\`..."
      case "$OSTYPE" in
      "darwin"*)
        darwin-rebuild switch --flake ".#$host"
        ;;
      "linux-gnu"*)
        sudo nixos-rebuild switch --flake ".#$host"
        ;;
      *)
        printf "unsupported os"
        exit 1
        ;;
      esac

      info "done!"
    }

    main
  '';

  code-update = with pkgs; pkgs.writeShellScriptBin "code-update" ''
    set -euo pipefail
    trap 'error_handler $?' EXIT
    trap clean_up SIGINT

    error_handler() {
      if [ "$1" != "0" ]; then
        error "command failed with exit status $1, aborting"
      fi
    }

    info() {
      local green='\033[1;32m'
      local clear='\033[0m'
      echo -e "''${green}info:''${clear} $1"
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

      info "updating vscode extensions..."
      cd '${path}'
      local exts_nix=$(printf '{\n  extensions = [\n' &&
        ${parallel}/bin/parallel --will-cite -k get_vsixpkg ::: "''${exts[@]}" &&
        printf '  ];\n}\n')
      echo "$exts_nix" >home/vscode/extensions.nix
    }

    export -f get_vsixpkg
    main
  '';
in
{
  environment.systemPackages = [ nix-switch code-update ];
}
