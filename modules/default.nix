{ pkgs, lib, system, ... }: {
  imports = [
    ./cachix.nix
    ./scripts.nix
    ./user.nix
  ];

  nix = {
    # Use flakes for **maximum hermeticism**.
    package = pkgs.nix_2_4;
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
  environment.systemPackages = with pkgs; [
    killall
  ];

  # Setup `home-manager`.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.opeik.imports = [ ../home ];
  };

  # Integrate with shells.
  programs = {
    fish.enable = true;
  };
}
