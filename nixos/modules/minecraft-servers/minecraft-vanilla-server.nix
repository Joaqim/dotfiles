{
  pkgs,
  lib,
  ...
}: let
  MINECRAFT_VERSION = "1.20.2";
  SERVER_NAME = "Minecraft Vanilla Server";
  SERVER_NAME_SLUG = lib.strings.toLower (lib.strings.sanitizeDerivationName SERVER_NAME);
in {
  # Runtime
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers = {
      backend = "docker";

      # Containers
      /*
         containers."rcon-web-admin" = {
        image = "itzg/rcon";
        environment = {
          RWA_USERNAME = "admin";
          RWA_PASSWORD = "admin";
          RWA_RCON_HOST = "${SERVER_NAME_SLUG}";

          RWA_RCON_PASSWORD = "hunter2";
        };
        ports = [
          "4326:4326"
          "4327:4327"
        ];
        extraOptions = [
          "--network-alias=rcon-web-admin"
          "--network=${SERVER_NAME_SLUG}_default"
        ];
      };
      */

      containers."${SERVER_NAME_SLUG}" = {
        image = "itzg/minecraft-server:java21-graalvm";
        environment = {
          ALLOW_FLIGHT = "TRUE";
          DEBUG = "FALSE";
          DIFFICULTY = "easy";
          EULA = "TRUE";
          LEVEL = "${SERVER_NAME} World 1";
          MAX_PLAYERS = "10";
          MEMORY = "16G";

          ENABLE_AUTOPAUSE = "TRUE";
          MAX_TICK_TIME = "-1";
          # More aggressive settings for demo purposes
          AUTOPAUSE_TIMEOUT_INIT = "600"; # 10 Minutes
          AUTOPAUSE_TIMEOUT_EST = "3600"; # 1 Hour

          MOTD = "Running `${SERVER_NAME}`";
          ONLINE_MODE = "FALSE";
          RCON_PASSWORD = "admin";
          SEED = "8016074285773694051";
          SERVER_NAME = "`${SERVER_NAME}`";
          SNOOPER_ENABLED = "FALSE";
          SPAWN_PROTECTION = "0";
          TZ = "Europe/Stockholm";
          USE_AIKAR_FLAGS = "TRUE";
          VERSION = MINECRAFT_VERSION;
          VIEW_DISTANCE = "15";
          WHITELIST = "TRUE";
        };
        volumes = [
          "/srv/minecraft/${SERVER_NAME_SLUG}-data:/data:rw"
        ];
        ports = [
          "25565:25565/tcp"
        ];
        log-driver = "journald";
        extraOptions = [
          "--network-alias=${SERVER_NAME_SLUG}"
          "--network=${SERVER_NAME_SLUG}_default"
        ];
      };
    };
  };
  systemd = {
    services = let
      service = "docker-network-${SERVER_NAME_SLUG}_default.service";
      target = "docker-compose-${SERVER_NAME_SLUG}-root.target";
    in {
      "docker-${SERVER_NAME_SLUG}" = {
        serviceConfig = {
          Restart = lib.mkOverride 500 "no";
        };
        restartIfChanged = true;

        after = [
          service
        ];
        requires = [
          service
        ];
        partOf = [
          target
        ];
        wantedBy = [
          target
        ];
      };

      # Networks
      "docker-network-${SERVER_NAME_SLUG}_default" = {
        path = [pkgs.docker];
        restartIfChanged = true;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "docker network rm -f ${SERVER_NAME_SLUG}_default";
        };
        script = ''
          docker network inspect ${SERVER_NAME_SLUG}_default || docker network create ${SERVER_NAME_SLUG}_default
        '';
        partOf = [target];
        wantedBy = [target];
      };
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    targets."docker-compose-${SERVER_NAME_SLUG}-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
