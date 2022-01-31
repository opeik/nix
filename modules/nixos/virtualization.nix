{ ... }: {
  # Enable Docker support.
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
}
