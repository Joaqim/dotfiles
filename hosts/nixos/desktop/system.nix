{
  my.system = {
    docker.enable = true;
    impermanence.enable = true;
    nix = {
      cache = {
        # This host is the one serving the cache, don't try to query it
        selfHosted = false;
      };
    };
    zram = {
      enable = true;
      kernelSysctl = true;
    };
  };
}
