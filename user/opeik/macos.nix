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
    global.brewfile = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
    };
    taps = ["homebrew/cask-drivers"];
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
      "loopback"
      "lulu"
      "lunar"
      "mos"
      "obs"
      "rectangle"
      "selfcontrol"
      "slack"
      "soundsource"
      "stats"
      "tailscale"
      "wireshark"
      "visual-studio-code"
      "yubico-authenticator"
    ];
  };
}
