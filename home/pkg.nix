{ pkgs, ... }: {
  # Install packages.
  home.packages = with pkgs; [
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
}
