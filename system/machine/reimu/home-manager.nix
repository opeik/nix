# home-manager extra configuration, see: <https://nix-community.github.io/home-manager/options>
{
  osConfig,
  root,
  ...
}: {
  home = {
    file.".hammerspoon/init.lua".source = "${root}/system/machine/reimu/hammerspoon.lua";
  };
}
