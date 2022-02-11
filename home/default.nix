{ pkgs, darwinConfig, ... }: {
  imports = [
    ./direnv.nix
    ./fish.nix
    ./font.nix
    ./git.nix
    ./pkg.nix
    ./starship.nix
    ./vscode
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = "21.11";
    username = darwinConfig.flake.user;
    homeDirectory = darwinConfig.flake.home;
  };
}
