{...}: {
  networking.hostName = "reimu";
  # Install homebrew apps.
  homebrew = {
    casks = [
      "1password"
      "appcleaner"
      "cameracontroller"
      "dbeaver-community"
      "discord"
      "docker"
      "firefox"
      "hammerspoon"
      "iina"
      "keka"
      "loopback"
      "lulu"
      "lunar"
      "mos"
      "obs"
      "rectangle"
      "saleae-logic"
      "selfcontrol"
      "slack"
      "soundsource"
      "stats"
      "tailscale"
      "visual-studio-code"
      "wireshark"
      "yubico-authenticator"
    ];
  };
}
