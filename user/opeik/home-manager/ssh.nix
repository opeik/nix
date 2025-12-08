# ssh client config, see: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
        extraOptions.IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      };

      "marisa.local" = {
        user = "opeik";
      };

      "pi-1.internal" = {
        user = "pi";
      };

      "mister" = {
        hostname = "10.0.1.3";
        user = "root";
      };
    };
  };
}
