# VSCode configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.vscode.enable>
{ pkgs, ... }: {
  programs.vscode = {
    enable = true; # Install VSCode, a cross platform text editor
    package = pkgs.unstable.vscode; # Use the latest version of VSCode
    mutableExtensionsDir = false; # Make the extensions dir immutable, fixing weird eval behavior

    # Install extensions, see: <https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions>
    extensions = with pkgs.unstable.vscode-extensions; [
      eamodio.gitlens # Git support
      jnoortheen.nix-ide # Nix support
      matklad.rust-analyzer # Rust support
      ms-azuretools.vscode-docker # Docker support
      ms-vscode-remote.remote-ssh # SSH support
      redhat.vscode-yaml # YAML support
      streetsidesoftware.code-spell-checker # Spell checking
      tamasfe.even-better-toml # TOML support
      timonwong.shellcheck # Shell linting
      usernamehw.errorlens # Improved error highlighting
      vadimcn.vscode-lldb # Debugger support
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Direnv support
      {
        name = "direnv";
        publisher = "mkhl";
        version = "0.6.1";
        sha256 = "5/Tqpn/7byl+z2ATflgKV1+rhdqj+XMEZNbGwDmGwLQ=";
      }
      # Pretty colors
      {
        name = "theme-monokai-pro-vscode";
        publisher = "monokai";
        version = "1.1.20";
        sha256 = "0ddwqsvsqdjblmb0xlad17czy2837g27ymwvzissz4b9r111xyhx";
      }
      # Lua support
      # {
      #   name = "lua";
      #   publisher = "sumneko";
      #   version = "3.5.3";
      #   sha256 = "toMcBXpKa/ik4TOy8st53k7B6RD2R7Zf4Ukvc3VULS4=";
      # }
    ];

    # VScode settings, see: <https://code.visualstudio.com/docs/getstarted/settings#_default-settings>
    userSettings = {
      "editor.autoClosingBrackets" = "always"; # Always close bracket pairs
      "editor.cursorBlinking" = "smooth"; # Enable cursor blinking
      "editor.cursorSmoothCaretAnimation" = true; # Enable cursor animations
      "editor.fontFamily" = "Iosevka, monospace";
      "editor.fontLigatures" = true; # Enable font ligatures
      "editor.fontSize" = 15; # Set font size
      "editor.fontWeight" = "700"; # Set font weight
      "editor.formatOnPaste" = true; # Automatically format pasted content
      "editor.formatOnSave" = true; # Automatically format files on save
      "editor.formatOnType" = true; # Automatically format a line after typing it
      "editor.guides.bracketPairs" = true; # Enable bracket pair guides
      "editor.inlayHints.fontSize" = 13;
      "editor.renderFinalNewline" = false; # Don't render the final newline in a file
      "editor.rulers" = [ 100 ]; # Render a vertical guide at 100 characters
      "editor.stickyTabStops" = true; # Make spaces behave like tabs
      "editor.suggest.preview" = true; # Preview suggestion outcomes in the editor
      "explorer.fileNesting.enabled" = true; # Allow files to be grouped
      "explorer.fileNesting.expand" = false; # Don't expand grouped files by default
      "explorer.fileNesting.patterns" = {
        "flake.nix" = "flake.lock";
        ".gitignore" = ".gitattributes, .gitmodules, .gitmessage, .mailmap, .git-blame*";
        "cargo.toml" = ".clippy.toml, .rustfmt.toml, cargo.lock, clippy.toml, cross.toml, rust-toolchain.toml, rustfmt.toml";
        "readme*" = "authors, backers*, changelog*, citation*, code_of_conduct*, codeowners, contributing*, contributors, copying, credits, governance.md, history.md, license*, maintainers, readme*, security.md, sponsors*";
      };
      "extensions.ignoreRecommendations" = true; # Silence recommended extension notifications
      "files.autoSave" = "afterDelay"; # Automatically save files after a delay
      "files.eol" = "\n"; # Always use Unix newline characters
      "files.exclude" = { "**/.DS_Store" = true; "**/.git" = true; "**/.direnv" = true; }; # Ignore metadata files
      "files.insertFinalNewline" = true; # Ensure files end with a newline
      "files.trimFinalNewlines" = true; # Trim extraneous newlines at the end of files
      "files.trimTrailingWhitespace" = true; # Trim trailing whitespace
      "telemetry.telemetryLevel" = "off"; # Disable telemetry
      "terminal.integrated.cursorStyle" = "line"; # Use line terminal cursor for legibility
      "terminal.integrated.fontSize" = 15; # Set terminal size
      "update.mode" = "none"; # Disable automatic updates
      "workbench.colorTheme" = "Monokai Pro"; # Set color theme
      "workbench.colorCustomizations" = {
        "[Monokai Pro]" = {
          "editorInlayHint.foreground" = "#868686f0";
          "editorInlayHint.background" = "#ff000000";
          "editorInlayHint.typeForeground" = "#aaa5aaf0";
          "editorInlayHint.parameterForeground" = "#fdb6fdf0";
        };
      };
      "workbench.iconTheme" = "Monokai Pro Icons"; # Set icon theme

      # Extension settings
      "cSpell.allowCompoundWords" = true; # Enable compound words such as "arraylength"
      "cSpell.enableFiletypes" = [ "nix" "shellscript" ]; # Additional file types to spellcheck
      "cSpell.ignoreWords" = [ "pkgs" "nixpkgs" "stdenv" " nixos" "aarch" "rustc" ]; # Common programming terms
      "evenBetterToml.formatter.alignComments" = false; # Disable TOML alignment against comments
      "git.enableStatusBarSync" = false; # Disable git sync status bar
      "gitlens.codeLens.enabled" = false; # Disables code block blame
      "gitlens.currentLine.enabled" = false; # Disables current line blame
      "gitlens.showWelcomeOnInstall" = false; # Disable welcome window
      "gitlens.showWhatsNewAfterUpgrades" = false; # Disable news window
      "Lua.hint.enable" = true; # Enable Lua type inlays
      "Lua.telemetry.enable" = false; # Disable Lua telemetry
      "nix.enableLanguageServer" = true; # Enable the rnix-lsp language server for Nix
      "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp"; # Set the path to rnix-lsp language server
      "redhat.telemetry.enabled" = false; # Disable telemetry
      "rust-analyzer.checkOnSave.command" = "clippy"; # Run clippy on save
      "shellcheck.exclude" = "SC2148"; # Ignore shell warning in direnv
      "vim.sneak" = true; # Enable sneak feature
    };
  };
}
