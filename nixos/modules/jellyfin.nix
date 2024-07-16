{flake, ...}: let
  inherit (flake.config.people) user0;
in {
  services = {
    jellyfin = {
      enable = true;
      dataDir = "/run/media/jq/Jellyfin";
      openFirewall = true;
      user = user0;
    };
    caddy = {
      enable = true;
      virtualHosts = {
        "jellybert.fun" = {
          extraConfig = ''
            reverse_proxy 10.0.0.239:8096
            tls {
              protocols tls1.2 tls1.3
            }
          '';
        };
      };
    };
    logrotate.enable = true;
  };
}
