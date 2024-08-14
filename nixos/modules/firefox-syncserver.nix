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

    secrets = builtins.toFile "sync-secrets" ''
      SYNC_MASTER_SECRET=${config.sops.secrets."firefox_syncserver_secret/jq"};
    '';
  };
}
