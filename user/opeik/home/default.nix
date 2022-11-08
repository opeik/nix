# home-manager extra configuration, see: <https://nix-community.github.io/home-manager/options>
{ pkgs, lib, osConfig, root, ... }: {
  # Import home-manager modules
  imports = [
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./vscode.nix
  ];

  home = {
    # Install packages
    packages = with pkgs; [
      docker # Docker container cli tools
      docker-compose # Docker container orchestrator
      git-town # Git workflow automation
      iosevka-bin # Pretty font
      ripgrep
    ] ++ (with pkgs.macos-apps; [
      docker-desktop # Docker macOS host
      mos # Mouse tweaks
      rectangle # Window snapping
      yubico-authenticator # Yubikey TOTP generator
    ]);

    file = {
      ".hammerspoon/init.lua".source = "${root}/user/opeik/hammerspoon.lua";
    };
  };


  macos = lib.mkIf pkgs.stdenv.isDarwin {
    shell = "/etc/profiles/per-user/${osConfig.username}/bin/fish"; # Set the user shell to fish
    aliasApps.enabled = true; # Alias .app bundles to ~/Applications
  };
}
