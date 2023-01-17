# nix-darwin extra configuration, see: <https://lnl7.github.io/nix-darwin/manual>
{...}: {
  security.pam.enableSudoTouchIdAuth = true;
}
