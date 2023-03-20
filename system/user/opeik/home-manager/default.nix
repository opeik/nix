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
        ripgrep # grep (in Rust!)
        du-dust # du (in Rust!)
        bat # cat (in Rust!)
        exa # ls (in Rust!)
        fd # find (in Rust!)
        procs # ps (in Rust!)
        sd # sed (in Rust!)
        bottom # top (in Rust!)
        jq # JSON swiss army knife.
        google-cloud-sdk # Google cloud
      ])
      ++ (with pkgs.unstable; [
        nil # Nix LSP.
      ]);

    sessionVariables = {
      DIRENV_LOG_FORMAT = ""; # Silence direnv output.
      SSH_AUTH_SOCK = "/Users/opeik/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"; # Setup git auth.
    };
  };

  macos = lib.mkIf pkgs.stdenv.isDarwin {
    shell = "/etc/profiles/per-user/${osConfig.username}/bin/fish"; # Set the user shell to fish
  };
}
