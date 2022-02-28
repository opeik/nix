# ssh configuration, see: <https://nix-community.github.io/home-manager/options.html#opt-programs.ssh.enable>
{ osConfig, ... }: {
  programs = {
    ssh = {
      enable = true; # Enable ssh, the secure remote shell
      # Setup per-host ssh keys
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          identityFile = "${osConfig.user.home}/.ssh/keys/github.com";
        };
      };
    };

    # Setup ssh-agent.
    fish.interactiveShellInit = ''
      set -e SSH_AUTH_SOCK; set -e SSH_AGENT_PID; set -xg SSH_ENV $HOME/.ssh/env

      function __ssh_agent_is_started
        if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
          source $SSH_ENV > /dev/null
        end

        if begin; test -z "$SSH_AGENT_PID"; and test -z "$SSH_CONNECTION"; end
          return 1
        end

        ssh-add -l > /dev/null 2>&1
        if test $status -eq 2
          return 1
        end
      end

      function __ssh_agent_start
        ssh-agent -c | head -n 2 > $SSH_ENV
        chmod 600 $SSH_ENV
        source $SSH_ENV > /dev/null
      end

      if not __ssh_agent_is_started
          __ssh_agent_start
      end
    '';
  };
}
