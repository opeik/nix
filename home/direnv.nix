{ ... }: {
  # Install `direnv` which allows the shell to integrate with `nix develop`.
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}
