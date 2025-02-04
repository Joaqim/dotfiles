{flake, ...}: let
  inherit (flake.config.people) user0;
  inherit (flake.inputs) jellyfin-plugins;
in {
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = user0;
      enabledPlugins = {inherit (jellyfin-plugins.packages."x86_64-linux") ani-sync;};
    };
    caddy = {
      enable = false;
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
