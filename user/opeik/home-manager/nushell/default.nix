# nushell configuration, see: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.enable
{
  config,
  osConfig,
  ...
}: let
  # Nushell encourages you to use the default config and apply your changes on top of it.
  defaults = {
    config = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nushell/nushell/0.95.0/crates/nu-utils/src/sample_config/default_config.nu";
      sha256 = "02qqjlhgyv4rcjzk8zvgk9q58fjykvrjkymi84gmnbhxw0j2pcrp";
    };
    env = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nushell/nushell/0.95.0/crates/nu-utils/src/sample_config/default_env.nu";
      sha256 = "03r7jinb2b0qgnycddibbspblf6h4136f0d3nn3x5kkir2ij0nhl";
    };
  };

  pathConfig = ''
    $env.PATH = (
        $env.PATH
        | split row (char esep)
        # Add macOS system paths.
        | append '/sbin'
        | append '/usr/sbin'
        | append '/usr/local/bin'
        # Add Nix paths.
        | append ($env.HOME | path join '.nix-profile/bin')
        | append '/etc/profiles/per-user/${osConfig.username}/bin'
        | append '/nix/var/nix/profiles/default/bin'
        | append '/run/current-system/sw/bin'
        # Add homebrew paths.
        | append '/opt/homebrew/bin'
        # Add application paths.
        | append '/Applications/Wireshark.app/Contents/MacOS'
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
