# atuin configuration, see: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.enable
{...}: {
  programs.atuin = {
    enable = true;
    settings = {
      enter_accept = true; # Upon hitting enter the command runs, press tab to return to the shell and edit.

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

        # Set commands that should be totally stripped and ignored from stats
        common_prefix = ["sudo"];

        # Set commands that will be completely ignored from stats
        ignored_commands = [
          "cd"
          "ls"
        ];
      };

      sync = {
        records = true; # Enable sync v2
        sync_frequency = "1m"; # How often the daemon should sync in seconds
      };
    };
  };
}
