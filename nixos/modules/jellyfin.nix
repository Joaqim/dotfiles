{
  flake,
  config,
  ...
}: let
  user = config.my.user.name;
  inherit (flake.inputs) jellyfin-plugins;
in {
  imports = [jellyfin-plugins.nixosModules.jellyfin-plugins];
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      inherit user;
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
