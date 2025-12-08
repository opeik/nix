# macOS home-manager config, see: https://nix-community.github.io/home-manager/options
{...}: {
  targets.darwin.copyApps.enable = false; # Don't copy anything to `~/Applications/Home Manager Apps`.
  programs.home-manager.enable = true; # Enable home-manager
  fonts.fontconfig.enable = true; # Enable font management
  home.stateVersion = "25.11"; # The home-manager and nixpkgs versions should match
  manual.manpages.enable = false; # Disable home-manager manpage generation.
}
