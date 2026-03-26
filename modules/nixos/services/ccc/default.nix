{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.ccc;
  inherit (inputs.ccc.packages."x86_64-linux") ccc;
in
{
  options.my.services.ccc = {
    enable = lib.mkEnableOption "CCC Minecraft-related service";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
      description = lib.mdDoc ''
        Port for the CCC service.
      '';
    };

    after = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "docker-minecraft-server.service" ];
      description = lib.mdDoc ''
        Systemd units to start after.
      '';
    };

    wants = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "docker-minecraft-server.service" ];
      description = lib.mdDoc ''
        Systemd units this service wants.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services."ccc" = {
      enable = true;
      restartIfChanged = true;
      inherit (cfg) after wants;
      path = [
        pkgs.tailscale
        pkgs.docker
        ccc
      ];
      script = ''
        set -ex
        export PORT=${toString cfg.port}
        tailscale serve --yes $PORT &>/dev/null &
        ccc
      '';
    };
  };
}
