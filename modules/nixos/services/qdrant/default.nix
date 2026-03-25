{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.qdrant;
in
{
  options.my.services.qdrant = {
    enable = lib.mkEnableOption "Enable Qdrant Vector Search Engine";
  };

  config = lib.mkIf cfg.enable {
    services.qdrant = {
      enable = true;
      settings.service = {
        host = lib.mkForce "0.0.0.0"; # Only local access ( or via VPN )
        # Explicit port definitions
        http_port = 6333;
        grpc_port = 6334;
      };
    };
  };
}
