# nix-darwin extra configuration, see: <https://lnl7.github.io/nix-darwin/manual>
{lib, ...}: {
  nix.settings.substituters = lib.mkBefore ["https://aseipp-nix-cache.freetls.fastly.net"];

  security.pam = {
    enableSudoTouchIdAuth = true;
    enableSudoWatchIdAuth = true;
  };

  # Install homebrew apps.
  homebrew = {
    enable = true;
    global = {
      brewfile = true;
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    taps = ["homebrew/cask" "homebrew/cask-drivers"];
    casks = [
      "1password"
      "appcleaner"
      "cameracontroller"
      "chiaki"
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
      "obs"
      "rectangle"
      "selfcontrol"
      "slack"
      "soundsource"
      "stats"
      "visual-studio-code"
      "wireshark"
      "yubico-authenticator"
      "zsa-wally"
    ];
  };
}
