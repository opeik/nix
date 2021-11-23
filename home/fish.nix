{ ... }: {
  # Install fish, the user friendly shell.
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting;   # Disable welcome message
      fish_vi_key_bindings # Enable vim key bindings
    '';
  };
}
