# nushell config, see: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.enable
{
  pkgs,
  config,
  osConfig,
  ...
}: let
  # Nushell encourages you to use the default config and apply your changes on top of it.
  defaults = {
    config = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nushell/nushell/refs/tags/0.104.0/crates/nu-utils/src/default_files/default_config.nu";
      sha256 = "JiEGuVJycoEQoFZUoGS7tB03evpSak7j8e8bPPN3vS8=";
    };
    env = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nushell/nushell/refs/tags/0.104.0/crates/nu-utils/src/default_files/default_env.nu";
      sha256 = "QrmNdYKQ/NBVLYJ+nL+27+Em+O/hPsCaRyvWveGYFJc=";
    };
  };

  pathConfig = ''
    $env.PATH = (
        # Add Nix paths.
        append ($env.HOME | path join '.nix-profile/bin')
        | append '/run/current-system/sw/bin'
        | append '/etc/profiles/per-user/${osConfig.username}/bin'
        | append '/nix/var/nix/profiles/default/bin'
        | append ($env.HOME | path join '.bin')
        # Add Homebrew paths.
        | append '/opt/homebrew/bin'
        # Add application paths.
        | append '/Applications/Wireshark.app/Contents/MacOS'
        | append '/Applications/Docker.app/Contents/Resources/bin'
        # Add existing paths.
        | append ($env.PATH | split row (char esep))
        # Remove any duplicate paths.
        | uniq
    )

    # sessionVariables aren't respected yet, set it manually.
    # See: https://github.com/nix-community/home-manager/issues/4620
    $env.SSH_AUTH_SOCK = '${config.home.sessionVariables.SSH_AUTH_SOCK}'
  '';

  configSection = name: contents:
    builtins.concatStringsSep "\n" [
      "### begin: home-manager: ${name}"
      "${contents}"
      "### end: home-manager: ${name}"
    ];
in {
  config.programs.nushell = {
    # package = pkgs.unstable.nushell;

    enable = true;
    configFile.text = (
      builtins.concatStringsSep "\n\n" [
        (configSection "default config.nu" (builtins.readFile defaults.config))
        (configSection "user config.nu" (builtins.readFile ./config.nu))
      ]
    );

    envFile.text = (
      builtins.concatStringsSep "\n\n" [
        (configSection "default env.nu" (builtins.readFile defaults.env))
        (configSection "nix paths" "${pathConfig}")
        (configSection "user env.nu" (builtins.readFile ./env.nu))
      ]
    );
  };
}
