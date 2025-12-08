# direnv config, see: https://nix-community.github.io/home-manager/options#opt-programs.direnv.enable
{...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Use the nix-direnv fork
    silent = true;
  };
}
