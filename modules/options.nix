{ config, lib, ... }: {
  options.flake = {
    user = with lib; mkOption {
      type = types.str;
      description = "desired username";
    };
    home = with lib; mkOption {
      type = types.str;
      description = "home directory";
      default = "/Users/${config.flake.user}";
    };
  };
}
