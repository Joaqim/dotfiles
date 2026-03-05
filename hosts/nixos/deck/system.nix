{ config, ... }:
let
  inherit (config.sops) secrets;
  #inherit (config.my.user) name;
  # Use my personal password for now
  name = "jq";
  defaultPasswordFile =
    if builtins.hasAttr "user_hashed_password/${name}" secrets then
      secrets."user_hashed_password/${name}".path
    else
      null;
in
{
  my.system = {
    nix.cache.selfHosted = true;
    users = {
      enable = true;
      #inherit defaultPasswordFile;
      initialPassword = "a";

      enableRootAccount = defaultPasswordFile != null;
      rootPasswordFile = defaultPasswordFile;
    };
  };
}
