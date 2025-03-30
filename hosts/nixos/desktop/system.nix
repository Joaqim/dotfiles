{
  my.system = {
    docker.enable = true;
    impermanence.enable = true;
    # This host is the one serving the cache, don't try to query it
    nix.cache.selfHosted = false;
    zram = {
      enable = true;
      kernelSysctl = true;
    };
  };
}
