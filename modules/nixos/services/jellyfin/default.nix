{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.my.services.jellyfin;
  inherit (inputs) jellyfin-plugins;
in
{
  imports = [
    jellyfin-plugins.nixosModules.jellyfin-plugins
  ];
  options.my.services.jellyfin = with lib; {
    enable = mkEnableOption "jellyfin";
    openFirewall = mkEnableOption "open firewall";
    user = mkOption {
      type = types.str;
      default = "jellyfin";
      description = "The user to run jellyfin as";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      inherit (cfg) openFirewall user;
      enable = true;

      enabledPlugins = {
        inherit (jellyfin-plugins.packages."x86_64-linux") ani-sync;
      };
    };
  };
}
