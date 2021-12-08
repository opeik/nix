{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    userSettings = {
      # Workbench
      "workbench.colorTheme" = "Monokai Pro";
      "workbench.iconTheme" = "Monokai Pro Icons";

      # Editor
      "editor.acceptSuggestionOnEnter" = "off";
      "editor.autoClosingBrackets" = "always";
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = true;
      "editor.cursorStyle" = "block";
      "editor.fontFamily" = "'FiraCode Nerd Font', monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 14;
      "editor.fontWeight" = "700";
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.renderFinalNewline" = false;
      "editor.rulers" = [ 80 ];
      "editor.smoothScrolling" = true;
      "editor.stickyTabStops" = true;
      "editor.suggest.preview" = true;

      # Terminal
      "terminal.integrated.fontSize" = 12;
      "terminal.integrated.allowChords" = false;
      "terminal.integrated.gpuAcceleration" = "on";
      "terminal.integrated.cursorStyle" = "line";
      "terminal.integrated.cursorBlinking" = true;

      # Files
      "files.autoSave" = "afterDelay";
      "files.eol" = "\n";
      "files.exclude" = {
        "**/.direnv" = true; # Direnv cache
        "**/.DS_Store" = true; # macOS Finder metadata
        "**/.git" = true; # Git data
        "**/.github" = true; # GitHub config
        "**/.gitignore" = true; # Git ignore file
        "**/.vscode" = true; # VSCode config
        "**/result" = true; # Rust build artifacts
        "**/target" = true; # Nix build artifacts
      };
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;

      # Remote SSH
      "remote.SSH.useLocalServer" = false;
      "remote.SSH.remotePlatform" = {
        "marisa.local" = "linux";
      };

      # Telemetry
      "telemetry.telemetryLevel" = "off";

      # Updates
      "update.mode" = "none";

      # Spelling
      "cSpell.allowCompoundWords" = true;
      "cSpell.spellCheckDelayMs" = 1000;
      "cSpell.showStatus" = false;

      # Git
      "git.enableStatusBarSync" = false;
      "git-graph.showStatusBarItem" = false;
      "gitlens.codeLens.enabled" = false; # Disables code block blame.
      "gitlens.currentLine.enabled" = false; # Disables current line blame.

      # Vim
      "vim.sneak" = true;

      # Languages
      ## Rust
      "crates.listPreReleases" = true;
      "rust-analyzer.experimental.procAttrMacros" = true;
      "rust-analyzer.checkOnSave.command" = "clippy";

      ## Nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      "nixEnvSelector.nixFile" = "\${workspaceRoot}/shell.nix";
      "[nix]" = { "editor.tabSize" = 2; };

      ## C/C++
      "C_Cpp.clang_format_fallbackStyle" = "LLVM";

      ## JSON
      "[json]" = { "editor.tabSize" = 2; };

      ## Shell
      "shellformat.path" = "${pkgs.shfmt}/bin/shfmt";

      ## Markdown
      "markdown.preview.doubleClickToSwitchToEditor" = false;
    };
  };
}
