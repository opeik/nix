{ pkgs, ... }: {
  # Use the `gnome` desktop environment.
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-dock # Makes the dock usable. Enable in the extensions app.
    gnome.gnome-tweaks # Extra settings to fiddle with.
  ];
}
