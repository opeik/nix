# starship configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.starship.enable>
{pkgs, ...}: {
  programs.starship = {
    enable = true; # Enable starship, the cross-shell prompt
    # starship settings, see: <https://starship.rs/config>
    settings = {
      username.show_always = true; # Always show username in prompt
      username.style_user = "bold bright-yellow"; # Improve contrast of username
    };
  };

  # Install powerline fonts for starship
  home.packages = with pkgs; [(nerdfonts.override {fonts = ["FiraCode"];})];
  # Show helpful command-not-found messages.
  programs.nix-index.enable = true;
}
