# System wide options
{ config, lib, ... }: {
  options.user = with lib; {
    username = mkOption {
      type = types.str;
      description = "user username";
    };
    home = mkOption {
      type = types.str;
      description = "user home directory path";
    };
    name = mkOption {
      type = types.str;
      description = "user name";
    };
    email = mkOption {
      type = types.str;
      description = "user email address";
    };
    useVim = mkOption {
      type = types.bool;
      default = false;
      description = "whether to enable vim mode";
    };
  };
}
