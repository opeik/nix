# Implements vim mode
{ pkgs, lib, config, ... }: {
  options.vim.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enables vim style modal editing for the user. This option adds vim mode to:
        - Visual Studio Code
        - Fish
    '';
  };

  config = lib.mkMerge [
    {
      programs.fish.interactiveShellInit = if config.vim.enable then "fish_vi_key_bindings" else "fish_default_key_bindings";
    }
    (lib.mkIf config.vim.enable {
      programs.vscode.extensions = (with pkgs.unstable.vscode-extensions; [ vscodevim.vim ]);
    })
  ];
}
