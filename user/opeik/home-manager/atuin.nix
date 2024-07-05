# atuin configuration, see: <https://nix-community.github.io/home-manager/options.xhtml#opt-programs.atuin.enable>
{...}: {
  programs.atuin = {
    enable = true;
    settings = {
      # Upon hitting enter Atuin will immediately execute the command. Press tab to return to the shell and edit.
      enter_accept = true;
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
        # Enable sync v2
        records = true;
        ## How often the daemon should sync in seconds
        sync_frequency = "1m";
      };
    };
  };
}
