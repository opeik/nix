{ config, ... }: {
  home-manager.users.${config.flake.user}.imports = [
    ./git.nix
    ./ssh.nix
  ];
}
