{
  pkgs,
  lib,
  ...
}: {
  systemd.services.liquidctl = {
    enable = lib.mkDefault true;
    description = "AIO Startup Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        ## AIO water cooler

        # set pump speed
        "-${pkgs.liquidctl}/bin/liquidctl --match Hydro initialize --pump-mode performance"
        # fan curve
        "-${pkgs.liquidctl}/bin/liquidctl --match Hydro set fan speed 20 50 34 80 90 100"
        # turn off RGB
        "-${pkgs.liquidctl}/bin/liquidctl --match Hydro set sync color fixed 000000"

        ## Motherboard

        # Initialize
        "-${pkgs.liquidctl}/bin/liquidctl --match Fusion initialize"
        # turn of RGB
        "-${pkgs.liquidctl}/bin/liquidctl --match Fusion set sync color fixed 000000"
      ];
    };
    after = ["network-online.target"];
    wants = ["network-online.target"];

    wantedBy = ["multi-user.target"];
  };
}
