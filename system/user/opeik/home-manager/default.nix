# home-manager extra configuration, see: <https://nix-community.github.io/home-manager/options>
{
  pkgs,
  lib,
  osConfig,
  root,
  ...
}: {
  # Import home-manager modules
  imports = [
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
  ];

  home = {
    # Install packages
    packages =
      (with pkgs; [
        docker # Docker container cli tools
        docker-compose # Docker container orchestrator
        git-town # Git workflow automation
        iosevka-bin # Pretty font
        ripgrep # Grep (in Rust)!
        jq # JSON swiss army knife.
        alejandra # Nix formatting.
      ])
      ++ (with pkgs.unstable; [
        nil # Nix LSP.
      ]);
  };

  macos = lib.mkIf pkgs.stdenv.isDarwin {
    shell = "/etc/profiles/per-user/${osConfig.username}/bin/fish"; # Set the user shell to fish
  };
}
