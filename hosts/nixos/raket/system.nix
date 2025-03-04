{
  my.system = {
    docker.enable = false;
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
