{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      daemon.enabled = true;
      sync_address = "http://desktop.joaqim.com:8888";
    };
  };

  systemd.user.services = {
    "atuind" = {
      Service = {
        Environment = "ATUIN_LOG=\"info\"";
        ExecStart = "${pkgs.atuin}/bin/atuin daemon";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
