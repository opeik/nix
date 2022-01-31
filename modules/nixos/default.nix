{ pkgs, ... }: {
  imports = [
    ./desktop.nix
    ./mdns.nix
    ./printer.nix
    ./virtualization.nix
  ];

  # nixOS version.
  system.stateVersion = "21.05";
  # Automatically optimize the Nix store.
  nix.autoOptimiseStore = true;

  # UTF-8 everywhere!
  i18n.defaultLocale = "en_US.UTF-8";
  # Set time zone.
  time.timeZone = "Australia/Perth";

  # Being replaced by `nix-index` soon™.
  # See: `https://github.com/NixOS/nixpkgs/issues/39789`.
  programs.command-not-found.enable = false;
}
