{...}: {
  networking.hostName = "marisa";
  # Install homebrew apps.
  homebrew = {
    casks = [
      "1password"
      "appcleaner"
      "discord"
      "firefox"
      "hammerspoon"
      "iina"
      "keka"
      "loopback"
      "lulu"
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
