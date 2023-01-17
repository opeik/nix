# Implements shell configuration
{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.macos.shell = lib.mkOption {
    type = lib.types.path;
    default = "/bin/zsh";
    description = "Set the macOS default shell for the user";
  };

  config.home.activation = let
    shell = config.macos.shell;
  in {
    setShell = lib.hm.dag.entryAfter ["writeBoundary"] ''
      PATH=$PATH:/usr/bin $DRY_RUN_CMD sudo chsh -s "${shell}" "${osConfig.username}" 2>&1 > /dev/null
    '';
  };
}
