# nix-darwin extra configuration, see: <https://lnl7.github.io/nix-darwin/manual>
{...}: {
  macos = {
    enableSudoTouchIdAuth = true; # Enable sudo TouchID auth
  };
}
