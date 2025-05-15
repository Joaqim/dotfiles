{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.services.caddy;
  inherit (config.networking) domain;

  inherit (config.my.user) email;

  certloc = "/var/lib/acme/joaqim.com";
in {
  options.my.services.caddy = with lib; {
    enable = mkEnableOption "enable caddy configuration";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    security.acme = {
      acceptTerms = true;
      defaults.email = email;

      certs."${domain}" = {
        inherit (config.services.caddy) group;
      };
    };

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/acmedns@v0.4.1"]; # TODO: Add selfup to automatically update version
        hash = "";
      };
      virtualHosts = {
        "${domain}" = {
          extraConfig = ''
            dns acmedns /tmp/acmedns-joaqim.com.json
          '';
        };
        "*.${domain}" = {
          extraConfig = ''
            dns acmedns /tmp/acmedns-joaqim.com.json
          '';
        };

        "jellyfin".extraConfig = ''
          reverse_proxy http://localhost:8096

          tsl ${certloc}/cert.perm ${certloc}/key.perm {
            protocols tls1.3
          }
        '';
        "localhost".extraConfig = ''
          respond "OK"
        '';
      };
    };
  };
}
