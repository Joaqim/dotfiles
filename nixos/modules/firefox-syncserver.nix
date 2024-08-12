{config, ...}: {
  services.firefox-syncserver = {
    enable = true;
    singleNode.enable = true;

    secrets = {
      SYNC_MASTER_SECRET = config.sops.secrets.firefox_syncserver_master_secret;
    };
  };
}
