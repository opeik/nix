# macOS (nix-darwin) homebrew config, see: https://daiderd.com/nix-darwin/manual/#opt-homebrew.enable
{...}: {
  homebrew = {
    enable = true;
    # global.brewfile = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall"; # When an app is removed from the cask list, remove it but leave its config intact.
    };
    casks = [
      "1password"
      "appcleaner"
      "cameracontroller"
      "dbeaver-community"
      "discord"
      "docker-desktop"
      "firefox"
      "hammerspoon"
      "iina"
      "iterm2"
      "keka"
      "kicad"
      "loopback"
      "lulu"
      "mos"
      "obs"
      "saleae-logic"
      "selfcontrol"
      "soundsource"
      "stats"
      "tailscale-app"
      "visual-studio-code"
      "wireshark-app"
      "yubico-authenticator"
    ];

    # App Store apps.
    masApps = {
      "Wireguard" = 1451685025;
    };
  };
}
