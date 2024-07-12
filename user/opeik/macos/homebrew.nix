# macOS (nix-darwin) homebrew config, see: https://daiderd.com/nix-darwin/manual/#opt-homebrew.enable
{...}: {
  homebrew = {
    enable = true;
    # global.brewfile = true;
    onActivation = {
      # autoUpdate = true;
      cleanup = "uninstall"; # When an app is removed from the cask list, remove it but leave its config intact.
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
}
