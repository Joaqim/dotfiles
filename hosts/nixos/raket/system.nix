{config, ...}: let
  inherit (config.sops) secrets;
in {
  my.system = {
    docker.enable = false;
    impermanence.enable = true;
    nix.cache.selfHosted = true;
    users = rec {
      enable = true;
      defaultPasswordFile =
        if builtins.hasAttr "user_hashed_password/jq" secrets
        then secrets."user_hashed_password/jq".path
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
