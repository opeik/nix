# fish configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.fish.enable>
{pkgs, ...}: {
  config.programs.nushell = {
    enable = true; # Enable fish, the new shell
    extraConfig = ''
      let $config = {
        show_banner: false
      }
    '';
  };
}
