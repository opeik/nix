# System options
{ pkgs, config, lib, root, ... }: {
  options = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "user username";
    };

    home = lib.mkOption {
      type = lib.types.str;
      description = "user home directory path";
      default = if pkgs.stdenv.isDarwin then "/Users/${config.username}" else "/home/${config.username}";
    };

    name = lib.mkOption {
      type = lib.types.str;
      description = "user name";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "user email address";
    };
  };
}
