{
  my.system = {
    docker.enable = false;
    impermanence.enable = true;
    nix = {
      cache = {
        # TODO: Enable when caching exists
        selfHosted = false;
      };
    };
    zram = {
      enable = true;
      kernelSysctl = true;
    };
  };
}
