{ pkgs, ... }: {
  # macOS (`nix-darwin`) verison.
  system.stateVersion = 4;
  # Enable the Nix build daemon.
  services.nix-daemon.enable = true;
  # Add additional allowed shells.
  environment.shells = [ pkgs.fish ];
  # Enable zsh otherwise things break.
  programs.zsh.enable = true;
}
