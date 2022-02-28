# home-manager configuration, see: <https://nix-community.github.io/home-manager/options.html>
{ pkgs, lib, ... }: {
  programs.home-manager.enable = true; # Enable home-manager
  fonts.fontconfig.enable = true; # Enable font management
  xdg.enable = true; # Enable XDG, required to write to `$XDG_CONFIG_HOME` aka `~/.config`
  home.stateVersion = "21.11"; # The home-manager and nixpkgs versions should match
}
