{ lib, pkgs, ... }: {
  # Install fish, the user friendly shell.
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting;   # Disable welcome message
      fish_vi_key_bindings # Enable vim key bindings
    '';
    shellAliases = lib.mkMerge [{ }
      (lib.mkIf pkgs.stdenv.isLinux {
        # Mimick the `open` command on macOS.
        "open" = "xdg-open";
      })];
  };
}
