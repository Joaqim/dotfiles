{
  config,
  pkgs,
  lib,
  ...
}:
# https://www.reddit.com/r/NixOS/comments/kn1pvj/comment/ghif5jg
let
  cfg = config.services.sleep-at-night;
  sleep-at-night = let
    date = lib.getExe' pkgs.coreutils "date";
    rtcwake = lib.getExe' pkgs.utillinux "rtcwake";
  in
    pkgs.writeScriptBin "sleep-at-night" ''
      #!${lib.getExe pkgs.bash}
      set -e
      wakeupTime="$3"
      shutdownHour="00$1"
      shutdownHour="''${shutdownHour:(-2)}"
      shutdownMinute="00$2"
      shutdownMinute="''${shutdownMinute:(-2)}"
      currentHour="$(${date} +%H)"
      currentMinute="$(${date} +%M)"

      # Calculate the duration until the shutdown time, ''${number#0} removes leading zeros, 09 -> 9
      currentSeconds=$(( ''${currentHour#0} * 3600 + ''${currentMinute#0} * 60 ))
      shutdownSeconds=$(( ''${shutdownHour#0} * 3600 + ''${shutdownMinute#0} * 60 ))
      duration=$(( shutdownSeconds - currentSeconds ))

      # If the duration is negative, the shutdown time is assumed to fall into the next day
      if [ $duration -lt 0 ]; then
        echo "Current time is $currentHour:$currentMinute. Planning shutdown tomorrow at $shutdownHour:$shutdownMinute."
        duration=$(( 24 * 3600 - currentSeconds + shutdownSeconds ))
      else
        echo "Current time is $currentHour:$currentMinute. Planning shutdown at $shutdownHour:$shutdownMinute."
      fi

      # Sleep for the duration
      if [ $duration -gt 0 ]; then
        echo "Sleeping for $(${date} -d "@$(( duration ))" -u '+%-H hours and %-M minutes')"
        sleep $(( duration ))
      fi

      echo "Shutting down now. Waking up at $wakeupTime".
      ${rtcwake} -m off -t "$(${date} -d "$wakeupTime" +%s)";
    '';
in
  with lib; {
    options = {
      services.sleep-at-night = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = ''
            Sleep at night.
            If you start the system after the given `shutdown` time, the system will keep running until the `shutdown` time occurs again, even if you start it before the given `wakeup` time.
          '';
        };

        wakeup = mkOption {
          default = "09:00:00";
          type = with types; str;
          description = ''
            Wake up at given time.
            The time has to be parsable by `date -d`.
          '';
        };

        shutdown = {
          hour = mkOption {
            default = 01;
            type = with types; ints.between 0 23;
            description = ''
              Shut down at given hour.
            '';
          };
          minute = mkOption {
            default = 00;
            type = with types; ints.between 0 59;
            description = ''
              Shut down at given minute of the given `hour`.
            '';
          };
        };
      };
    };

    config = mkIf cfg.enable {
      systemd.services.sleep-at-night = {
        description = "Sleep at night.";
        serviceConfig = {
          ExecStart = "${sleep-at-night}/bin/sleep-at-night ${toString cfg.shutdown.hour} ${toString cfg.shutdown.minute} ${cfg.wakeup}";
          Restart = "on-success";
          RestartSec = 30;
          User = "root";
        };
        wantedBy = ["multi-user.target"];
      };
    };
  }
