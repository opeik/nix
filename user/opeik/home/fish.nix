# fish configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.fish.enable>
{ pkgs, lib, config, osConfig, ... }:
let
  monokai = builtins.fetchGit {
    url = "https://github.com/benmarten/Monokai_Fish_OSX.git";
    rev = "c665d9e45a7a0ec92be336deab5ac35eabfc8a8c";
  };
in
{
  # Themes shouldn't be set in the common config but the default is violating WCAG contrast requirements
  options.programs.fish.monokai.enabled = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Use the monokai theme";
  };

  config.programs.fish = {
    enable = true; # Enable fish, the user friendly shell
    interactiveShellInit = ''
      # Disable welcome message
      set fish_greeting;
      # Fix path priority, see: <https://github.com/LnL7/nix-darwin/issues/122>
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin \
        /etc/profiles/per-user/${osConfig.username}/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin;
    '' + (
      if config.programs.fish.monokai.enabled then "source ${monokai}/set_colors.fish;"
      else "source ${monokai}/reset_colors.fish"
    );
  };
}
