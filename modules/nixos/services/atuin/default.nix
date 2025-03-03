{
  config,
  lib,
  ...
}: let
  cfg = config.my.services.atuin;
in {
  options.my.services.atuin = with lib; {
    enable = mkEnableOption "atuin server";
    openRegistration = mkEnableOption "Allow registrations";
  };
  config = lib.mkIf cfg.enable {
    services.atuin = {
      inherit (cfg) enable openRegistration;
      # Ensures we only have access through tailscale node, even if the default port `8888` happens to be open.
      host = "0.0.0.0";
    };
  };
}
