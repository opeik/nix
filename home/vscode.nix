{ pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Prefer the packaged version for extensions which require binaries,
      # such as language servers.
      vadimcn.vscode-lldb
      matklad.rust-analyzer
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # To fetch new extension versions, run `./fetch-vscode-ext.sh`. Make sure
      # you remove the packaged extensions listed above from the list.
      {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "1.0.7";
        sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "11.7.0";
        sha256 = "0apjjlfdwljqih394ggz2d8m599pyyjrb0b4cfcz83601b7hk3x6";
      }
      {
        name = "shell-format";
        publisher = "foxundermoon";
        version = "7.2.2";
        sha256 = "00wc0y2wpdjs2pbxm6wj9ghhfsvxyzhw1vjvrnn1jfyl4wh3krvi";
      }
      {
        name = "vscode-pull-request-github";
        publisher = "GitHub";
        version = "0.33.2021120110";
        sha256 = "1rpqw7295xpfr1l6b4x62gqp8x8qgsb32gjdycsbjkqnkbvi4kph";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.18";
        sha256 = "1v3j67j8bydyqba20b2wzsfximjnbhknk260zkc0fid1xzzb2sbn";
      }
      {
        name = "git-graph";
        publisher = "mhutchie";
        version = "1.30.0";
        sha256 = "000zhgzijf3h6abhv4p3cz99ykj6489wfn81j0s691prr8q9lxxh";
      }
      {
        name = "theme-monokai-pro-vscode";
        publisher = "monokai";
        version = "1.1.19";
        sha256 = "0skzydg68bkwwwfnn2cwybpmv82wmfkbv66f54vl51a0hifv3845";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.18.0";
        sha256 = "0hhlhx3xy7x31xx2v3srvk67immajs6dm9h0wi49ii1rwx61zxah";
      }
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.66.1";
        sha256 = "0qj2ihl74bk1fbixv0g1qzdvaxh4skqww22dyaf17rs6cjf19zps";
      }
      {
        name = "crates";
        publisher = "serayuzgur";
        version = "0.5.10";
        sha256 = "1dbhd6xbawbnf9p090lpmn8i5gg1f7y8xk2whc9zhg4432kdv3vd";
      }
      {
        name = "code-spell-checker";
        publisher = "streetsidesoftware";
        version = "2.0.13";
        sha256 = "0r5l8fi68j3i2qy453lwxf7z8f476pvcps1pn6aaz50yc71bv3cq";
      }
      {
        name = "even-better-toml";
        publisher = "tamasfe";
        version = "0.14.2";
        sha256 = "17djwa2bnjfga21nvyz8wwmgnjllr4a7nvrsqvzm02hzlpwaskcl";
      }
      {
        name = "errorlens";
        publisher = "usernamehw";
        version = "3.4.1";
        sha256 = "1mr8si7jglpjw8qzl4af1k7r68vz03fpal1dr8i0iy4ly26pz7bh";
      }
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.21.10";
        sha256 = "0c9m7mc2kmfzj3hkwq3d4hj43qha8a75q5r1rdf1xfx8wi5hhb1n";
      }
    ];

    userSettings = lib.mkMerge [
      {
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
          "**/.direnv/" = true; # Direnv build artifacts
          "**/.DS_Store" = true; # macOS Finder directory metadata
          "**/.git" = true; # Git data
          "**/result" = true; # Rust build artifacts
          "**/target" = true; # Nix build output
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
      }
    ];
  };
}
