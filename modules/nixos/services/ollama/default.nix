{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.ollama;
in
{
  options.my.services.ollama = {
    enable = lib.mkEnableOption "Ollama LLM service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama;
      defaultText = lib.literalExpression "pkgs.ollama";
      description = lib.mdDoc ''
        The ollama package to use.
      '';
    };

    rocmOverrideGfx = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = lib.mdDoc ''
        ROCm GPU override for AMD graphics cards.
      '';
    };

    loadModels = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = lib.mdDoc ''
        List of models to load on startup.
      '';
    };

    environmentVariables = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = lib.mdDoc ''
        Environment variables to set for the Ollama service.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        The host address to bind to.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 11434;
      description = lib.mdDoc ''
        The port to listen on.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      inherit (cfg)
        package
        rocmOverrideGfx
        loadModels
        environmentVariables
        host
        port
        ;
    };
  };
}
