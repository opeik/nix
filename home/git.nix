{ ... }: {
  # Install `git`, the stupid content tracker.
  programs.git = {
    enable = true;
    userName = "Sandro Stikić";
    # Global file ignores.
    ignores = [ ".DS_Store" ];
    extraConfig = {
      core = {
        # Always use Unix line endings.
        eol = "lf";
        # Don't automatically convert line endings.
        autocrlf = false;
        # Use VSCode as the commit message editor.
        editor = "code --wait";
      };
      # Use VSCode as the merge tool.
      merge.tool = "vscode";
      # Use VSCode as the diff tool.
      diff.tool = "vscode";
      difftool.vscode.cmd = "code --wait --diff $LOCAL $REMOTE";
      # Use `main` as the default branch name.
      init.defaultBranch = "main";
      # Always rebase instead of merge.
      pull.rebase = true;
      # Use the same branch names on the local and remote end.
      push.default = "current";
      # Automatically stash unstaged changes then reapply after an action completes.
      rebase.autoStash = true;
    };
  };
}
