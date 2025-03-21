{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.liquidctl];
  systemd.services.liquidctl = let
    liquidctl = lib.getExe pkgs.liquidctl;
  in {
    enable = lib.mkDefault true;
    description = "AIO Startup Service";
    path = [
      pkgs.liquidctl
    ];
    serviceConfig = {
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
}
