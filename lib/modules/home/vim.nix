# Implements user vim mode
{ config, lib, pkgs, ... }:
with lib;
{
  options.vim.enable = lib.mkOption {
    type = types.bool;
    default = false;
    description = "Enable vim mode";
  };

  config = mkIf config.vim.enable {
    programs.fish.interactiveShellInit = "fish_vi_key_bindings; # Enable vim mode";
    programs.vscode.extensions = with pkgs.unstable.vscode-extensions; [ vscodevim.vim ];
  };
}
