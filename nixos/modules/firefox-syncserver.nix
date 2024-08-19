{
  config,
  pkgs,
  ...
}: {
  services.mysql.package = pkgs.mariadb;
  services.firefox-syncserver = {
    enable = true;
    singleNode = {
      enable = true;
      hostname = "syncserver";
      url = "http://syncserver:5000";
    };

    secrets = config.sops.templates."firefox-syncserver.env".path;
  };
}
