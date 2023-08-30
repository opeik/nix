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
      # cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
