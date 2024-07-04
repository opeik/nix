# macOS home-manager configuration, see: <https://nix-community.github.io/home-manager/options>
{...}: {
  programs.home-manager.enable = true; # Enable home-manager
  fonts.fontconfig.enable = true; # Enable font management
  home.stateVersion = "24.05"; # The home-manager and nixpkgs versions should match
  manual.manpages.enable = false; # Disable home-manager manpage generation.
}
