# nushell config, see: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.enable
{
  config,
  osConfig,
  ...
}: let
  # Nushell encourages you to use the default config and apply your changes on top of it.
  defaults = {
    config = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nushell/nushell/0.96.1/crates/nu-utils/src/sample_config/default_config.nu";
      sha256 = "1mibr101b93g0vw09icvzcylkf6k8dl9zspljawr3v4zvlx28jqr";
    };
    env = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nushell/nushell/0.96.1/crates/nu-utils/src/sample_config/default_env.nu";
      sha256 = "1gsyg29knmdl63fc01rn6bf8v5w7g3lk2md1sb68ccqriv25kpj6";
    };
  };

  pathConfig = ''
    $env.PATH = (
        # Add Nix paths.
        append ($env.HOME | path join '.nix-profile/bin')
        | append '/run/current-system/sw/bin'
        | append '/etc/profiles/per-user/${osConfig.username}/bin'
        | append '/nix/var/nix/profiles/default/bin'
        # Add Homebrew paths.
        | append '/opt/homebrew/bin'
        # Add application paths.
        | append '/Applications/Wireshark.app/Contents/MacOS'
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
