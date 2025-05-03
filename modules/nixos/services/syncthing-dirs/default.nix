{
  config,
  lib,
  ...
}: let
  user = config.my.user.name;
  cfg = config.my.services.syncthing-dirs;
in {
  options.my.services.syncthing-dirs = with lib; {
    enable = mkEnableOption (mdDoc "Syncthing");

    dataDir = mkOption {
      type = types.path;
      default = "/home/${user}/Syncthing";
      description = mdDoc ''
        The directory where Syncthing stores its data files.
      '';
    };

    user = mkOption {
      type = types.str;
      default = user;
      description = mdDoc ''
        User account permissions to sync with.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "users";
      description = mdDoc ''
        Group permissions to sync with.
      '';
    };

    guiPort = mkOption {
      type = types.port;
      default = 8384;
      description = mdDoc ''
        Syncthing web UI port.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Open my.services.syncthing-dirs.guiPort to the outside network.
      '';
    };

    guiHost = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = mdDoc ''
        Syncthing web UI address.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.guiPort 22000];
    };

    services = {
      syncthing = {
        inherit (cfg) dataDir user group;
        enable = true;
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
