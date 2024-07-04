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
