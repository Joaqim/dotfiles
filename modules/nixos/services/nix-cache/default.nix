# Binary cache
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.nix-cache;
in
{
  options.my.services.nix-cache = with lib; {
    enable = mkEnableOption "nix binary cache";

    harmonia = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Enable harmonia binary cache server";
      };

      ipAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "127.0.0.1";
        description = "IP address for serving harmonia cache";
      };

      listenPort = mkOption {
        type = types.port;
        default = 5000;
        description = "Internal port for serving harmonia cache";
      };

      secretKeyFile = mkOption {
        type = types.str;
        example = "/run/secrets/nix-cache-harmonia";
        description = "Secret signing key for the harmonia cache";
      };

      priority = mkOption {
        type = types.int;
        default = 50;
        example = 30;
        description = ''
          Which priority to assign to this cache. Lower number is higher priority.
          The official nixpkgs hydra cache is priority 40.
        '';
      };
    };

    atticd = {
      enable = mkEnableOption "atticd binary cache server";

      ipAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "127.0.0.1";
        description = "IP address for serving atticd cache";
      };

      listenPort = mkOption {
        type = types.port;
        default = 8080;
        description = "Port for serving atticd cache";
      };

      secretKeyFile = mkOption {
        type = types.str;
        example = "/run/secrets/nix-cache-atticd";
        description = "Environment file containing secrets for atticd";
      };

      apiEndpoint = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "https://domain.tld/attic/";
        description = ''
          The API endpoint of this service if exposed to the public internet
          Must end with a slash (e.g., `https://domain.tld/attic/`
          For security, this should be configure in production environments
          See: https://github.com/zhaofengli/attic/blob/main/server/src/config-template.toml
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Assertions to prevent conflicts
      {
        assertions = [
          {
            assertion =
              (cfg.harmonia.enable && cfg.atticd.enable)
              -> !(
                cfg.harmonia.ipAddress == cfg.atticd.ipAddress && cfg.harmonia.listenPort == cfg.atticd.listenPort
              );
            message = "my.services.nix-cache: harmonia and atticd should probably not share the same address";
          }
        ];
      }

      # Harmonia configuration
      (lib.mkIf cfg.harmonia.enable {
        services.harmonia = {
          enable = true;

          settings = {
            bind = "${cfg.harmonia.ipAddress}:${toString cfg.harmonia.listenPort}";
            inherit (cfg.harmonia) priority;
          };

          signKeyPaths = [ cfg.harmonia.secretKeyFile ];
        };
      })

      # Atticd configuration
      (lib.mkIf cfg.atticd.enable {
        environment.systemPackages = [
          pkgs.attic-client
        ];

        services.atticd = lib.mkMerge [
          {
            enable = true;
            environmentFile = cfg.atticd.secretKeyFile;
            # Internally, this uses toTOML which only allows TOML values, we use empty string instead of null
            settings = {
              listen = "${cfg.atticd.ipAddress}:${toString cfg.atticd.listenPort}";
              api-endpoint = lib.strings.optionalString (cfg.atticd.apiEndpoint != null) cfg.atticd.apiEndpoint;
            };
          }
        ];
      })
    ]
  );
}
