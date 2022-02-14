{ pkgs, config, ... }:
let
  path = "${config.users.users.${config.flake.user}.home}/Development/nix";

  rebuild = with pkgs; writeShellScriptBin "rebuild" ''
    set -euo pipefail

    run() {
      echo -e "\033[1;32minfo:\033[0m running \`''${@:1}\`" && "''${@:1}"
    }

    CONFIG="''${1-$(hostname)}"
    run cd '${path}'
    run ${git}/bin/git add flake.lock '*.nix' && run ${git}/bin/git pull --quiet
    run nix build ".#darwinConfigurations.$CONFIG.config.system.build.toplevel"
    run ./result/sw/bin/darwin-rebuild switch --flake ".#$CONFIG"
  '';

  code-update = with pkgs; pkgs.writeShellScriptBin "code-update" ''
    set -euo pipefail
    trap clean_up SIGINT

    clean_up() {
      local tmp_dir="''${TMPDIR:-/tmp}"
      echo "killed, cleaning up tmpdirs: \`$tmp_dir/vscode_exts_*\`" >&2
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
  environment.systemPackages = [ rebuild code-update ];
}
