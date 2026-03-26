{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.komga;
in
{
  options.my.services.komga = {
    enable = lib.mkEnableOption "Komga comic/manga server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Open Komga port to the outside network.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "komga";
      description = lib.mdDoc ''
        Group under which Komga runs.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 25600;
      description = lib.mdDoc ''
        Komga web UI port.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.komga = {
      enable = true;
      inherit (cfg) openFirewall group;
      settings = {
        server.port = cfg.port;
      };
    };
  };
}
