# direnv configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.direnv.enable>
{...}: {
  programs.fish.interactiveShellInit = "export DIRENV_LOG_FORMAT='';"; # Silence chatter
  programs.direnv = {
    enable = true; # Enable direnv, the environment switcher
    nix-direnv = {
      enable = true; # Use the nix-direnv fork
    };
  };
}
