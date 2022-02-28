# fish configuration, see: <https://nix-community.github.io/home-manager/options.html#opt-programs.fish.enable>
{ pkgs, osConfig, ... }: {
  programs.fish = {
    enable = true; # Enable fish, the user friendly shell
    interactiveShellInit = ''
      set fish_greeting; # Disable welcome message
      fish_default_key_bindings; # Use the default key bindings
      # Fix path priority, see: <https://github.com/LnL7/nix-darwin/issues/122>
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin \
        /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin;
    '';
  };
}
