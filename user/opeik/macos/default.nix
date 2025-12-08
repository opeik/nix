# Extra macOS (nix-darwin) config, see:
# https://lnl7.github.io/nix-darwin/manual
# LINK: os/macos/default.nix
{
  pkgs,
  lib,
  config,
  root,
  ...
}: let
  # Convenience command that rebuilds and applies the system config.
  nixy = pkgs.writeShellScriptBin "nixy" ''
    main() {
      local target="$1"

      if [ -z "$target" ]; then
        target="$(hostname)"
      fi

      set -x
      cd /Users/${config.username}/Development/nix
      ${pkgs.git}/bin/git add .
      sudo darwin-rebuild switch --flake ".#$target"
      set +x
    }

    main "$1"
  '';
in {
  imports = [./homebrew.nix];

  # Use the new Nix binary cache.
  nix = {
    settings.substituters = lib.mkBefore ["https://aseipp-nix-cache.freetls.fastly.net"];
  };

  # Enable Apple TouchID and WatchID sudo auth.
  security.pam = {
    services.sudo_local.touchIdAuth = true;
  };

  # Add nushell as a valid login shell.
  environment = {
    systemPackages = [nixy pkgs.nushell];
    shells = [pkgs.nushell];
  };

  # Start the atuin daemon.
  launchd = {
    user.agents.atuin = {
      script = ''
        rm -f "$HOME"/.local/share/atuin/atuin.sock
        ${pkgs.atuin}/bin/atuin daemon
      '';

      serviceConfig = {
        RunAtLoad = true;
        StandardOutPath = "/tmp/atuin.log";
      };
    };

    daemons.nix-cleanup = {
      command = "${./nix-cleanup.sh} 2>&1";
      serviceConfig = {
        RunAtLoad = true;
        StandardOutPath = "/tmp/nix-cleanup.log";
        StartInterval = 60 * 60 * 24; # In seconds.
      };
    };
  };
}
