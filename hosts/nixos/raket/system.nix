{ config, ... }:
let
  inherit (config.sops) secrets;
  inherit (config.my.user) name;
in
{
  my.system = {
    doas.enable = false; # Doesn't play nicely with `nixos-rebuild --sudo` which expects `sudo`, not daos shim
    docker.enable = false;
    impermanence.enable = true;
    nix.cache.selfHosted = true;
    users = rec {
      enable = true;
      defaultPasswordFile =
        if builtins.hasAttr "user_hashed_password/${name}" secrets then
          secrets."user_hashed_password/${name}".path
        else
          null;

      enableRootAccount = defaultPasswordFile != null;
      rootPasswordFile = defaultPasswordFile;
    };
    zram = {
      enable = true;
      kernelSysctl = true;
    };
  };
}
