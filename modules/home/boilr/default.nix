{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.boilr;
in
{
  options.my.home.boilr = with lib; {
    enable = mkEnableOption "boilr service to automatically add artwork to non-Steam shortcuts";

    runOnStartup = my.mkDisableOption "add artwork on startup using systemd service";
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        pkgs.boilr
      ];
    };
    sops.templates."boilr-config.toml" = {
      content =
        builtins.readFile ./config.toml
        + ''

          auth_key = "${config.sops.placeholder."steamgrid_db_auth_key"}"
        '';
      path = "${config.home.homeDirectory}/.config/boilr/config.toml";
    };

    systemd.user.services.boilr = lib.mkIf cfg.runOnStartup {
      Unit = {
        Description = "Run Boilr without gui to automatically add artwork to non-Steam shortcuts.";
        After = [
          "NetworkManager.target"
          "sops-nix.service"
        ];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.boilr} --no-ui";
        Restart = "on-failure";
        Type = "oneshot";
      };
      Install = {
        WantedBy = [ "multi-user.target" ];
      };
    };
  };
}
