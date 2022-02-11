{ ... }: {
  # Install direnv, allowing shells to integrate with Nix devshells.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
