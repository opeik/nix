# home-manager extra configuration, see: https://nix-community.github.io/home-manager/options
{...}: {
  home = {
    file.".hammerspoon/init.lua".source = ./hammerspoon.lua;
  };
}
