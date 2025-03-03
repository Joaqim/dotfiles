# Filter and ban unauthorized access
{
  config,
  lib,
  ...
}: let
  cfg = config.my.services.fail2ban;
in {
  options.my.services.fail2ban = with lib; {
    enable = mkEnableOption "fail2ban daemon";
  };

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;

      ignoreIP = [
        # Loopback addresses
        "127.0.0.0/8"
      ];

      maxretry = 5;

      bantime-increment = {
        enable = true;
        rndtime = "5m"; # Use 5 minute jitter to avoid unban evasion
      };

      jails.DEFAULT.settings = {
        findtime = "4h";
        bantime = "10m";
      };
    };
  };
}
