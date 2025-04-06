{config, ...}: let
  inherit (config.sops) secrets;
  inherit (config.my.user) name;
in {
  my.system = {
    nix.cache.selfHosted = true;
    users = rec {
      enable = true;
      defaultPasswordFile =
        if builtins.hasAttr "user_hashed_password/${name}" secrets
        then secrets."user_hashed_password/${name}".path
        else null;

      enableRootAccount = true;
      rootPasswordFile = defaultPasswordFile;
    };
  };
}
