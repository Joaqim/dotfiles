{
  pkgs,
  lib,
  ...
}: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      daemon.enabled = true;
      sync_address = "http://desktop.joaqim.com:8888";
    };
  };

  systemd.user.services = {
    "atuind" = let
      atuin = lib.getExe pkgs.atuin;
    in {
      Service = {
        Environment = "ATUIN_LOG=\"info\"";
        ExecStart = "${atuin} daemon";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
