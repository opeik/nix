# direnv configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.direnv.enable>
{ ... }: {
  programs.direnv = {
    enable = true; # Enable direnv, the environment switcher
    nix-direnv = {
      enable = true; # Use the nix-direnv fork
    };
  };
}
