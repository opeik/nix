# fish configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.fish.enable>
{...}: {
  config.programs.nushell = {
    enable = true; # Enable fish, the new shell
    configFile.text = ''
      $env.config = {
        show_banner: false,
      }
    '';
  };
}
