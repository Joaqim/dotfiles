{
  config,
  pkgs,
  lib,
  ...
}:
# https://www.reddit.com/r/NixOS/comments/kn1pvj/comment/ghif5jg
let
  cfg = config.services.sleep-at-night;
  sleep-if-night = pkgs.writeScriptBin "sleep-if-night" ''
    #!${lib.getExe pkgs.bash}
    wakeupTime="$3"
    shutdownHour="00$1"
    shutdownHour="''${shutdownHour:(-2)}"
    shutdownMinute="00$2"
    shutdownMinute="''${shutdownMinute:(-2)}"
    currentHour="$(${pkgs.coreutils}/bin/date +%H)"
    currentMinute="$(${pkgs.coreutils}/bin/date +%M)"
    if [[ "$currentHour" -eq "$shutdownHour" ]] && [[ "$currentMinute" -eq "$shutdownMinute" ]]
    then
        echo "Shutting down now. Waking up at $wakeupTime".
        ${pkgs.utillinux}/bin/rtcwake -m off -t "$(${pkgs.coreutils}/bin/date -d "$wakeupTime" +%s)";
    else
        echo "Current time is $currentHour:$currentMinute. Shutting down at $shutdownHour:$shutdownMinute."
        exit 0
    fi
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
          ExecStart = "${sleep-if-night}/bin/sleep-if-night ${toString cfg.shutdown.hour} ${toString cfg.shutdown.minute} ${cfg.wakeup}";
          Restart = "on-success";
          RestartSec = 30;
          User = "root";
        };
        wantedBy = ["multi-user.target"];
      };
    };
  }
