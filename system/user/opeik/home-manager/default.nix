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
        bat # cat (in Rust!)
        bottom # top (in Rust!)
        docker # Docker container cli tools
        docker-compose # Docker container orchestrator
        du-dust # du (in Rust!)
        exa # ls (in Rust!)
        fd # find (in Rust!)
        git-town # Git workflow automation
        google-cloud-sdk # Google cloud
        iosevka-bin # Pretty font
        jq # JSON swiss army knife.
        procs # ps (in Rust!)
        ripgrep # grep (in Rust!)
        sd # sed (in Rust!)
        tealdeer # Manpages, but readable (in Rust!)
      ])
      ++ (with pkgs.unstable; [
        nil # Nix LSP.
      ]);

    sessionVariables = {
      SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"; # Setup git auth.
      DIRENV_LOG_FORMAT = "";
    };

    shellAliases = with pkgs; {
      ls = "${exa}/bin/exa";
      cat = "${bat}/bin/bat";
    };
  };

  macos = lib.mkIf pkgs.stdenv.isDarwin {
    shell = "/etc/profiles/per-user/${osConfig.username}/bin/fish"; # Set the user shell to fish
  };
}
