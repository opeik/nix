# nix-darwin extra configuration, see: <https://lnl7.github.io/nix-darwin/manual>
{ pkgs, lib, root, ... }: {
  macos = {
    enableSudoTouchIdAuth = true; # Enable sudo TouchID auth
  };
}
