{config, ...}: let
  inherit (config.sops) secrets;
  inherit (config.my.user) name;
in {
  my.system = {
    docker.enable = true;
    impermanence.enable = true;
    nix.cache = {
      # This host is the one serving the cache, don't try to query it
      selfHosted = false;
      nixGaming = true;
    };
    users = rec {
      enable = true;
      defaultPasswordFile =
        if builtins.hasAttr "user_hashed_password/${name}" secrets
        then secrets."user_hashed_password/${name}".path
        else null;

      enableRootAccount = true;
      rootPasswordFile = defaultPasswordFile;
    };
    zram = {
      enable = true;
      kernelSysctl = true;
    };
  };
}
