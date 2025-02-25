{
  config,
  flake,
  lib,
  ...
}:
with lib; let
  cfg = config.services.syncthing-dirs;
  inherit
    (flake.config.people)
    user0
    ;
in {
  options.services.syncthing-dirs = {
    enable = mkEnableOption (lib.mdDoc "Syncthing");

    user = mkOption {
      type = types.str;
      default = user0;
      description = lib.mdDoc ''
        User account permissions to sync with.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "users";
      description = lib.mdDoc ''
        Group permissions to sync with.
      '';
    };

    guiPort = mkOption {
      type = types.port;
      default = 8384;
      description = lib.mdDoc ''
        Syncthing web UI port.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open services.syncthing-dirs.guiPort to the outside network.
      '';
    };

    guiHost = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = lib.mdDoc ''
        Syncthing web UI address.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.guiPort 22000];
    };

    services = {
      syncthing = rec {
        enable = true;
        inherit (cfg) user group;
        dataDir = "/home/${user}/Syncthing";
        guiAddress = "${cfg.guiHost}:${toString cfg.guiPort}";
        # overrides any devices or folders added or deleted through the WebUI
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          # https://docs.syncthing.net/users/config.html#folder-element
          # TODO: https://docs.syncthing.net/users/config.html#config-option-folder.type
          folders = {
            "~/Documents" = {
              id = "default-home-Documents";
              devices = ["node" "desktop"]; # Shared with devices `node` & `desktop`
              paused = true;
            };
            "~/.local/share/PrismLauncher" = {
              id = "default-PrismLauncher";
              devices = ["node" "deck"];
            };
            "~/.config/undertaker141" = {
              id = "default-UnderTaker141";
              devices = ["node" "desktop"];
            };
          };
          devices = {
            "desktop" = {
              addresses = [
                "tcp://100.119.143.95:22000"
              ];
              id = "AGRFPBN-T4ONKDY-FBUJ4I5-WSH2WIO-HP647BY-RLLEOTU-HRLVHKA-POHYXAE";
            };
            "node" = {
              addresses = [
                "tcp://100.96.18.126:22000"
              ];
              id = "7SQCVXX-UMARZFP-PGL46E3-TVTQ244-3GMTVZX-UUW6VPF-YV6DPDE-FQYYOQR";
            };
            "deck" = {
              addresses = [
                "tcp://100.76.25.84:22000"
              ];
              id = "GS5HYYH-EJZL3KK-FEBLNTS-CQXVFMI-26V4XLI-GBGTDHN-2JEPP6Y-6UZG5QZ";
            };
          };
        };
      };
    };
  };
}
