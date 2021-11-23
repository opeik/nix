{ ... }: {
  # Enable the `starship` prompt.
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      battery.disabled = true;
      nix_shell = {
        symbol = "⛄ ";
        format = ''via [$symbol$state( $name)]($style) '';
      };
    };
  };
}
