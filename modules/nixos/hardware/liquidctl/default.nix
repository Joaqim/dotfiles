{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.hardware.liquidctl;
in {
  options.my.hardware.liquidctl = with lib; {
    enable = mkEnableOption "liquidctl configuration for AIO water cooler and Motherboard";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.liquidctl];
    systemd.services.liquidctl = {
      enable = true;
      description = "AIO Startup Service";
      path = [
        pkgs.liquidctl
      ];
      serviceConfig = let
        liquidctl = lib.getExe pkgs.liquidctl;
      in {
        Type = "oneshot";
        ExecStart = [
          ## AIO water cooler

          # set pump speed
          "-${liquidctl} --match Hydro initialize --pump-mode performance"
          # fan curve
          "-${liquidctl} --match Hydro set fan speed 20 50 34 80 90 100"
          # turn off RGB
          "-${liquidctl} --match Hydro set sync color fixed 000000"

          ## Motherboard

          # Initialize
          "-${liquidctl} --match Fusion initialize"
          # turn of RGB
          "-${liquidctl} --match Fusion set sync color fixed 000000"
        ];
      };

      wantedBy = ["multi-user.target" "sleep.target" "resume.target"];
    };
  };
}
