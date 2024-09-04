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
      hostname = "desktop";
    };

    secrets = config.sops.templates."firefox-syncserver.env".path;
  };
  ## https://github.com/ellmau/nixos/blob/f0c01f8c387702ae092e5eb23f8b9656241ef41c/modules/server/firefox.nix#L14

  # user is not created by firefox syncserver
  users.users.firefox-syncserver = {
    group = "firefox-syncserver";
    isSystemUser = true;
  };

  users.groups.firefox-syncserver.members = ["firefox-syncserver"];
}
