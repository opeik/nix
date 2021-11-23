{ pkgs, ... }: {
  # Enable user-level font management.
  fonts.fontconfig.enable = true;
  # Install fonts.
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraCode" ];
    })
  ];
}
