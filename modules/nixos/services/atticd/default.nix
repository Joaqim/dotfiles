{
  config,
  lib,
  ...
}: let
  cfg = config.my.services.atticd;
in {
  options.my.services.atticd = with lib; {
    enable = mkEnableOption "attic server";
    ipAddress = mkOption {
      type = with types; either int str;
      default = "[::]";
      description = "The IP address the cache is available at";
    };
    listenPort = mkOption {
      type = types.port;
      default = 8080;
      description = "The port to listen on";
    };
    environmentFile = mkOption {
      type = types.path;
      default = "/etc/atticd.env";
      description = "The environment file to use";
    };
  };
  config = lib.mkIf cfg.enable {
    services.atticd = {
      enable = true;

      inherit (cfg) environmentFile;

      settings = {
        listen = "${toString cfg.ipAddress}:${toString cfg.listenPort}";

        jwt = {};
      };
    };
  };
}
