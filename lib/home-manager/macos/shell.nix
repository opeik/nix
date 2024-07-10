# macOS home-manager module allowing users to set their shell.
{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  shell = "/run/current-system/sw${config.macos.shell.shellPath}";
in {
  options.macos.shell = lib.mkOption {
    type = lib.types.shellPackage;
    default = pkgs.zsh;
    description = "Set the macOS default shell for the user";
  };

  config.home.activation.set-shell = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -x
    if [ ! -e "${shell}" ]; then
      echo 'shell `${shell}` does not exist'
      exit 1
    fi

    if ! ${shell} -c true; then
      echo 'shell `${shell}` failed the vibe check'
      exit 1
    fi

    PATH=$PATH:/usr/bin run sudo chsh -s "${shell}" "${osConfig.username}" 2>&1 > /dev/null
    set +x
  '';
}
