# Unstable package overlay
{unstable}: final: prev: {
  unstable = import unstable {
    system = prev.system; # Use the system's architecture
    config.allowUnfree = true; # Enable proprietary packages
  };
}
