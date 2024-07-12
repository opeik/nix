# atuin config, see: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.enable
{...}: {
  programs.atuin = {
    enable = true;
    # atuin settings, see: https://docs.atuin.sh/configuration/config
    settings = {
      enter_accept = true; # Upon hitting enter the command runs, press tab to return to the shell and edit.
      style = "compact";
      inline_height = 25;
      daemon.enabled = true; # Enable the background daemon

      sync = {
        records = true; # Enable sync v2
        sync_frequency = "1m";
      };

      stats = {
        # Set commands where we should consider the subcommand for statistics. Eg, kubectl get vs just kubectl
        common_subcommands = [
          "cargo"
          "docker"
          "git"
          "go"
          "ip"
          "kubectl"
          "nix"
          "brew"
        ];

        common_prefix = ["sudo"];
        ignored_commands = ["cd" "ls"];
      };
    };
  };
}
