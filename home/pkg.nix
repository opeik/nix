{ pkgs, lib, system, ... }:
let
  packages = with pkgs; [
    # Development tools
    ## Version control systems
    git
    ## Text editors
    vim
    ## Container orchestration
    docker-compose

    # Utilities
    htop # Interactive proccess viewer
    wally-cli # Firmware flasher for ZSA keyboards
    jq # JSON processor
    git-town # Git workflow helper
  ];
  macosPackages = with pkgs; [ ];
  nixosPackages = with pkgs; [
    _1password-gui # Password manager
  ];
in
{
  home.packages = packages
    ++ lib.optionals pkgs.stdenv.isDarwin macosPackages
    ++ lib.optionals pkgs.stdenv.isLinux nixosPackages;
}
