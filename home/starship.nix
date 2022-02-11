{ ... }: {
  # Enable the `starship` prompt.
  xdg.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      hostname.ssh_only = false;
      battery.disabled = true;
      nix_shell = {
        symbol = "⛄ foo";
        format = ''via [$symbol$state( $name)]($style) '';
      };
    };
  };
}
