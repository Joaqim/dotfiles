{config, ...}: let
  user = config.home.username;
  gammaConfig = import ./config-${user};
in {
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    inherit
      (gammaConfig)
      temperature
      dawnTime
      duskTime
      ;
  };
}
