# Extra home-manager config, see:
# https://nix-community.github.io/home-manager/options
# LINK: os/macos/home-manager.nix
{
  osConfig,
  pkgs,
  lib,
  ...
}: {
  # Import home-manager modules
  imports = [
    ./atuin.nix
    ./direnv.nix
    ./firefox
    ./git.nix
    ./nushell
    ./ssh.nix
    ./starship.nix
  ];

  home = {
    # Install packages
    packages = with pkgs; [
      bat # cat (in Rust!)
      bottom # top (in Rust!)
      docker # Docker container CLI tools
      docker-compose # Docker container orchestrator
      terraform # Terraform CLI tools
      du-dust # du (in Rust!)
      eza # ls (in Rust!)
      fd # find (in Rust!)
      git-town # Git workflow automation
      # Google cloud
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      kubectl # Kubernetes utilities
      # Pretty fonts
      iosevka-bin
      roboto
      source-sans-pro
      source-sans
      font-awesome
      jq # JSON swiss army knife
      procs # ps (in Rust!)
      ripgrep # grep (in Rust!)
      sd # sed (in Rust!)
      tealdeer # Manpages, but readable (in Rust!)
      colima # Docker daemon
      nil # Nix LSP
      difftastic # git diffs that don't suck
      atuin
    ];

    sessionVariables = {
      # Authenticate git via 1Password.
      SSH_AUTH_SOCK = "/Users/${osConfig.username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    };

    shellAliases = with pkgs; {
      ls = "${eza}/bin/eza";
      cat = "${bat}/bin/bat";
    };
  };

  macos = lib.mkIf pkgs.stdenv.isDarwin {
    shell = pkgs.unstable.nushell; # Set the user shell to fish
  };
}
