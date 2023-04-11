{pkgs, ...}: {
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "marisa.local".user = "opeik";
      "pi-1.local".user = "pi";
      "*".extraOptions.IdentityAgent = "'~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock'";
    };
  };
}
