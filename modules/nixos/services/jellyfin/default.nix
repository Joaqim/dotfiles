{
  config,
  lib,
}: let
  cfg = config.my.services.jellyfin;
in {
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
    };
  };
}
