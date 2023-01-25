# nix-darwin extra configuration, see: <https://lnl7.github.io/nix-darwin/manual>
{...}: {
  security.pam = {
    enableSudoTouchIdAuth = true;
    enableSudoWatchIdAuth = true;
  };

  # Install homebrew apps.
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };
    taps = ["homebrew/cask" "homebrew/cask-drivers"];
    casks = [
      "1password"
      "appcleaner"
      "cameracontroller"
      "chiaki"
      "discord"
      "docker"
      "firefox"
      "hammerspoon"
      "iina"
      "keka"
      "loopback"
      "lunar"
      "obs"
      "rectangle"
      "selfcontrol"
      "soundsource"
      "stats"
      "visual-studio-code"
      "wireshark"
      "yubico-authenticator"
      "zsa-wally"
    ];
  };
}
