# Extra macOS (nix-darwin) config, see:
# https://lnl7.github.io/nix-darwin/manual
# LINK: os/macos/default.nix
{
  pkgs,
  lib,
  config,
  ...
}: let
  # Convenience command that rebuilds and applies the system config.
  nixos-rebuild = pkgs.writeShellScriptBin "nixos-rebuild" ''
    main() {
      local target="$1"

      if [ -z "$target" ]; then
        target="$(hostname)"
      fi

      cd /Users/${config.username}/Development/nix
      ${pkgs.git}/bin/git add .
      nix build ".#darwinConfigurations.$target.system" --show-trace
      ./result/sw/bin/darwin-rebuild switch --flake ".#$target"
    }

    main "$1"
  '';
in {
  imports = [./homebrew.nix];

  # Use the new Nix binary cache.
  nix.settings.substituters = lib.mkBefore ["https://aseipp-nix-cache.freetls.fastly.net"];

  # Enable Apple TouchID and WatchID sudo auth.
  security.pam = {
    enableSudoTouchIdAuth = true;
    enableSudoWatchIdAuth = true;
  };

  # Install homebrew apps.
  homebrew = {
    enable = true;
    global.brewfile = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
    };
    casks = [
      "1password"
      "appcleaner"
      "cameracontroller"
      "dbeaver-community"
      "discord"
      "firefox"
      "hammerspoon"
      "iina"
      "keka"
      "kicad"
      "loopback"
      "lulu"
      "lunar"
      "mos"
      "obs"
      "rectangle"
      "saleae-logic"
      "selfcontrol"
      "soundsource"
      "stats"
      "tailscale"
      "visual-studio-code"
      "wireshark"
      "yubico-authenticator"
    ];
  };

  # Add nushell as a valid login shell.
  environment = {
    systemPackages = [nixos-rebuild pkgs.nushell];
    shells = with pkgs; [nushell];
  };

  # Start the atuin daemon.
  launchd.user.agents.atuin = {
    command = "${pkgs.atuin}/bin/atuin daemon";
    serviceConfig = {
      RunAtLoad = true;
      StandardOutPath = "/tmp/atuin.log";
    };
  };
}
