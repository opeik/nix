{ lib, config, pkgs, darwinConfig, ... }: {
  imports = [
    ./app.nix
    ./direnv.nix
    ./fish.nix
    ./font.nix
    ./git.nix
    ./pkg.nix
    ./starship.nix
    ./vscode
  ];

  home = {
    # Ensure home-managers's state version is the same as the nixpkgs version.
    stateVersion = "21.11";
    username = darwinConfig.flake.user;
    homeDirectory = darwinConfig.flake.home;
  };

  # Enable home-manager.
  programs.home-manager.enable = true;
  xdg.enable = true;
}
