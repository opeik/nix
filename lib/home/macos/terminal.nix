# Implements Terminal.app configuration
{ config, lib, pkgs, ... }: {
  options.macos.terminal.font = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Set the macOS Terminal.app font for the user";
  };

  config.home.activation =
    let
      font = config.macos.terminal.font;
      timeout = "${pkgs.coreutils}/bin/timeout";
    in
    lib.mkIf (! isNull font) {
      setTerminalFont = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${timeout} 5s osascript -e '
        tell application "Terminal"
            set profiles to name of every settings set
                repeat with profile in profiles
                    set font name of settings set profile to "${font}"
            end repeat
        end tell'
      '';
    };
}
