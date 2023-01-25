# fish configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.fish.enable>
{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  monokai = builtins.fetchGit {
    url = "https://github.com/benmarten/Monokai_Fish_OSX.git";
    rev = "c665d9e45a7a0ec92be336deab5ac35eabfc8a8c";
  };
  merge-history = {
    name = "merge-history";
    src = builtins.fetchGit {
      url = "https://github.com/2m/fish-history-merge";
      rev = "7e415b8ab843a64313708273cf659efbf471ad39";
    };
  };
in {
  config.programs.fish = {
    enable = true; # Enable fish, the user friendly shell
    interactiveShellInit = ''
      set fish_greeting # Disable welcome message.
      fish_vi_key_bindings # Enable vim bindings.
      # Fix path priority, see: <https://github.com/LnL7/nix-darwin/issues/122>
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin \
        /etc/profiles/per-user/${osConfig.username}/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
      fish_add_path --append --path /opt/homebrew/bin # Add homebrew binaries to the path.
      source ${monokai}/set_colors.fish # Use the monokai theme.
    '';
    plugins = [merge-history];
  };
}
