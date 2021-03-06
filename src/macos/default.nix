# nix-darwin extra configuration, see: <https://lnl7.github.io/nix-darwin/manual/index.html>
{ ... }: {
  security.pam.enableSudoTouchIdAuth = true; # Enable sudo TouchID auth
  system.defaults = {
    dock = {
      autohide = true; # Automatically hide the dock
      mineffect = "scale"; # Use the scale minimization effect
      show-recents = false; #  Don't keep recently used apps in the dock
    };
  };
}
