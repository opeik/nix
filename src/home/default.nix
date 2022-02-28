# home-manager extra configuration, see: <https://nix-community.github.io/home-manager/options.html>
{ pkgs, osConfig, ... }: {
  # Import home-manager modules
  imports = [
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./vscode.nix
  ];

  vim.enable = osConfig.user.useVim; # Enable vim mode if applicable

  # Install packages
  home.packages = with pkgs; [
    docker # Docker container engine
    docker-compose # Docker container orchestrator
    openssh # Secure remote shell
    yubikey-manager # Yubikey command line management
  ];

  macos = {
    manageApps = true; # Alias .app bundles to ~/Applications
    shell = "/etc/profiles/per-user/${osConfig.user.username}/bin/fish"; # Set the user shell to fish
    terminal.font = "FiraCode Nerd Font"; # Set the macOS Terminal.app font to Fira Code
  };
}
