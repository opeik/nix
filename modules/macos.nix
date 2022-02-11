{ pkgs, ... }: {
  # macOS (`nix-darwin`) verison.
  system.stateVersion = 4;
  # Enable the Nix build daemon.
  services.nix-daemon.enable = true;
}
