# home-manager extra configuration, see: <https://nix-community.github.io/home-manager/options>
{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  # git configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.git.enable>
  programs.git = {
    # git settings, see: <https://git-scm.com/docs/git-config#_variables>
    extraConfig = {
      # Enable code signing via 1Password.
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIecOpIZJm2t6IPK/FBsNN26eoIAKVHt/IP+8irtjXs4";
      commit.gpgsign = true;
    };
  };
}
