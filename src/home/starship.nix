# starship configuration, see: <https://nix-community.github.io/home-manager/options.html#opt-programs.starship.enable>
{ pkgs, ... }: {
  programs.starship = {
    enable = true; # Enable starship, the cross-shell prompt
    # starship settings, see: <https://starship.rs/config>
    settings = {
      hostname.ssh_only = false; # Always show hostname in prompt
    };
  };

  # Install powerline fonts for starship
  home.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
}
