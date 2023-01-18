# nix-darwin extra configuration, see: <https://lnl7.github.io/nix-darwin/manual>
{...}: {
  security.pam.enableSudoTouchIdAuth = true;

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
      "docker"
      "firefox"
      "postman"
      "rectangle"
      "slack"
      "stats"
      "visual-studio-code"
      "wireshark"
      "yubico-authenticator"
    ];
  };
}
