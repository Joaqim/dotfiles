{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.open-webui;
in
{
  options.my.services.open-webui = {
    enable = lib.mkEnableOption "Open WebUI for Ollama";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        The host address to bind to.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = lib.mdDoc ''
        The port to listen on.
      '';
    };

    environment = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = lib.mdDoc ''
        Environment variables for Open WebUI.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.open-webui = {
      enable = true;
      inherit (cfg) host port environment;
    };
  };
}
