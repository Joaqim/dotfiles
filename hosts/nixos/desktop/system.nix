{
  my.system = {
    nix = {
      cache = {
        # This host is the one serving the cache, don't try to query it
        selfHosted = false;
      };
    };
  };
}
