# VSCode configuration, see: <https://nix-community.github.io/home-manager/options.html#opt-programs.vscode.enable>
{ pkgs, ... }: {
  programs.vscode = {
    enable = true; # Install VSCode, a cross platform text editor
    package = pkgs.unstable.vscode; # Use the latest version of VSCode
    # Install extensions, see: <https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions>
    extensions = with pkgs.unstable.vscode-extensions; [
      arrterian.nix-env-selector # Nix shell support
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
      {
        name = "theme-monokai-pro-vscode";
        publisher = "monokai";
        version = "1.1.20";
        sha256 = "0ddwqsvsqdjblmb0xlad17czy2837g27ymwvzissz4b9r111xyhx";
      }
    ];
    # VScode settings, see: <https://code.visualstudio.com/docs/getstarted/settings#_default-settings>
    userSettings = {
      "editor.accessibilitySupport" = "off"; # Fig compatibility
      "editor.autoClosingBrackets" = "always"; # Always close bracket pairs
      "editor.cursorBlinking" = "smooth"; # Enable cursor blinking
      "editor.cursorSmoothCaretAnimation" = true; # Enable cursor animations
      "editor.cursorStyle" = "block"; # Use a block cursor
      "editor.fontFamily" = "'FiraCode Nerd Font', monospace"; # Set the font family
      "editor.fontSize" = 13; # Set font size
      "editor.fontWeight" = "700"; # Set font weight
      "editor.fontLigatures" = true; # Enable font ligatures
      "editor.formatOnPaste" = true; # Automatically format pasted content
      "editor.formatOnSave" = true; # Automatically format files on save
      "editor.formatOnType" = true; # Automatically format a line after typing it
      "editor.guides.bracketPairs" = true; # Enable bracket pair guides
      "editor.renderFinalNewline" = false; # Don't render the final newline in a file
      "editor.rulers" = [ 100 ]; # Render a vertical guide at 100 characters
      "editor.stickyTabStops" = true; # Make spaces behave like tabs
      "editor.suggest.preview" = true; # Preview suggestion outcomes in the editor
      "files.autoSave" = "afterDelay"; # Automatically save files after a delay
      "files.eol" = "\n"; # Always use Unix newline characters
      "files.exclude" = { "**/.DS_Store" = true; "**/.git" = true; }; # Ignore metadata files
      "files.insertFinalNewline" = true; # Ensure files end with a newline
      "files.trimFinalNewlines" = true; # Trim extraneous newlines at the end of files
      "files.trimTrailingWhitespace" = true; # Trim trailing whitespace
      "telemetry.telemetryLevel" = "off"; # Disable telemetry
      "update.mode" = "none"; # Disable automatic updates
      "workbench.colorTheme" = "Monokai Pro"; # Set color theme
      "workbench.iconTheme" = "Monokai Pro Icons"; # Set icon theme
      "workbench.colorCustomizations" = {
        # Use monokai colors for the bracket guides
        "editorBracketHighlight.foreground1" = "#EF6E89";
        "editorBracketHighlight.foreground2" = "#EF9E6D";
        "editorBracketHighlight.foreground3" = "#F8DA71";
        "editorBracketHighlight.foreground4" = "#B0DA7D";
        "editorBracketHighlight.foreground5" = "#AC9EEF";
        "editorBracketHighlight.foreground6" = "#8FD9E7";
        "editorBracketHighlight.unexpectedBracket.foreground" = "#65CBDE";
      };

      # Extension settings
      "cSpell.allowCompoundWords" = true; # Enable compound words such as "arraylength"
      "cSpell.enableFiletypes" = [ "nix" "shellscript" ]; # Additional file types to spellcheck.
      "git.enableStatusBarSync" = false; # Disable git sync status bar
      "gitlens.codeLens.enabled" = false; # Disables code block blame
      "gitlens.currentLine.enabled" = false; # Disables current line blame
      "gitlens.showWelcomeOnInstall" = false; # Disable install welcome
      "gitlens.showWhatsNewAfterUpgrades" = false; # Disable news on updates
      "nix.enableLanguageServer" = true; # Enable the rnix-lsp language server for Nix
      "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp"; # Set the path to rnix-lsp language server
      "nixEnvSelector.nixFile" = "\${workspaceRoot}/shell.nix"; # Automatically load Nix environments
      "redhat.telemetry.enabled" = false; # Disable telemetry
      "rust-analyzer.checkOnSave.command" = "clippy"; # Run clippy on save
      "vim.sneak" = true; # Enable sneak feature
    };
  };
}
