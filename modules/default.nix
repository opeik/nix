{ pkgs, config, ... }: {
  imports = [
    ./cachix.nix
    ./options.nix
    ./scripts.nix
    ./user.nix
  ];

  # Use Nix flakes for **maximum hermeticism**.
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      # Uses more disk space but speeds up nix-direnv.
      keep-derivations = true
      keep-outputs = true
    '';
  };

  # Allow proprietary packages.
  nixpkgs.config.allowUnfree = true;
  # System-wide packages.
  environment.systemPackages = with pkgs; [ ];

  # Integrate with shells.
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  # Setup `home-manager`.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.flake.user} = import ../home;
  };
}
