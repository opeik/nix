{ pkgs, lib, config, ... }: {
  # Define users.
  users.users.${config.flake.user} = {
    home = config.flake.home;
  };
}
