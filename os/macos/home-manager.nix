# macOS home-manager config, see: https://nix-community.github.io/home-manager/options
{...}: {
  programs.home-manager.enable = true; # Enable home-manager
  fonts.fontconfig.enable = true; # Enable font management
  home.stateVersion = "24.11"; # The home-manager and nixpkgs versions should match
  manual.manpages.enable = false; # Disable home-manager manpage generation.
}
