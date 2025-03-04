{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.boilr;
in {
  options.my.home.boilr = with lib; {
    enable = mkEnableOption "boilr service to automatically add artwork to non-Steam shortcuts";
  };
  config = lib.mkIf cfg.enable {
    # Make boilr executable available
    home.packages = [pkgs.boilr];
    systemd.user.services.boilr = {
      Unit = {
        Description = "Run Boilr without gui to automatically add artwork to non-Steam shortcuts.";
        After = ["NetworkManager.target"];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.boilr} --no-ui";
        Restart = "on-failure";
        Type = "oneshot";
      };
      Install = {
        WantedBy = ["multi-user.target"];
      };
    };
  };
}
