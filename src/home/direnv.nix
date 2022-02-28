# direnv configuration, see: <https://nix-community.github.io/home-manager/options.html#opt-programs.direnv.enable>
{ ... }: {
  programs.direnv = {
    enable = true; # Enable direnv, the environment switcher
    nix-direnv = {
      enable = true; # Use the nix-direnv fork
      enableFlakes = true; # Enable flake support
    };
  };
}
