{
  pkgs,
  lib,
  config,
  ...
}: let
  MINECRAFT_VERSION = "1.21.3";
  MODPACK_NAME = "Minecraft Modpack";

  MODPACK_VERSION = "2025.02.22-rc2";
  MODS_FILE_PATH = builtins.toFile "mods.txt" ''
    # Dynamic Lights - Server-Side, doesn't work 2024-11-28:
    #https://cdn.modrinth.com/data/7YjclEGc/versions/Uuh7PGja/dynamiclights-v1.8.4-mc1.17x-1.21x-mod.jar
    #
    https://cdn.modrinth.com/data/gWO6Zqey/versions/1olfoAAA/vanilla-refresh-1.4.26a_1.21.3.jar
  '';
  REMOTE_MODPACK_URL = "https://github.com/Joaqim/MinecraftModpack/raw/${MODPACK_VERSION}";
  SERVER_NAME = "Minecraft Server";
  SERVER_NAME_SLUG = lib.strings.toLower (lib.strings.sanitizeDerivationName SERVER_NAME);
  WHITELIST_FILE_PATH = config.sops.secrets."minecraft_server_whitelist".path;
in {
  # Runtime
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers = {
      backend = "docker";

      containers = {
        "rcon-web-admin" = {
          image = "itzg/rcon";
          # https://github.com/rcon-web-admin/rcon-web-admin#environment-variables
          environment = {
            RWA_RCON_HOST = "${SERVER_NAME_SLUG}"; # See docker container `itzg/minecraft-server`: --network-alias=${SERVER_NAME_SLUG}
          };
          environmentFiles = [config.sops.secrets."rcon_web_admin_env".path];
          ports = [
            "4326:4326"
            "4327:4327"
          ];
          extraOptions = [
            "--network-alias=rcon-web-admin"
            "--network=${SERVER_NAME_SLUG}_default"
          ];
        };

        "${SERVER_NAME_SLUG}" = {
          image = "itzg/minecraft-server:java21-graalvm";
          environment = rec {
            inherit SERVER_NAME;
            ALLOW_FLIGHT = "TRUE";
            AUTOPAUSE_TIMEOUT_EST = "3600"; # 1 Hour
            AUTOPAUSE_TIMEOUT_INIT = "600"; # 10 Minutes
            CUSTOM_SERVER_PROPERTIES = ''
              allow-cheats=true
            '';
            DEBUG = "FALSE";
            DIFFICULTY = "easy";
            ENABLE_AUTOPAUSE = "TRUE";
            EULA = "TRUE";
            LEVEL = "${SERVER_NAME} World 1";
            MAX_PLAYERS = "10";
            MAX_TICK_TIME = "-1";
            MEMORY = "4G";
            #MODS_FILE = "/extras/mods.txt";
            MOTD = "Running `${MODPACK_NAME}` version ${MODPACK_VERSION}";
            ONLINE_MODE = "FALSE";
            OP_PERMISSION_LEVEL = "4"; # https://minecraft.fandom.com/wiki/Permission_level#Java_Edition
            #PACKWIZ_URL = "${REMOTE_MODPACK_URL}/pack.toml";
            RCON_CMDS_STARTUP = ''
              gamerule keepInventory true
              gamerule mobGriefing false
              gamerule playersSleepingPercentage 0
              gamerule doImmediateRespawn true
              gamerule doInsomnia false
              gamerule disableElytraMovementCheck true
            '';
            SEED = "8016074285773694051";
            SERVER_ICON = "${REMOTE_MODPACK_URL}/icon.jpeg";
            SNOOPER_ENABLED = "FALSE";
            SPAWN_PROTECTION = "0";
            #TYPE = "FORGE";
            TZ = "Europe/Stockholm";
            USE_AIKAR_FLAGS = "TRUE";
            VERSION = MINECRAFT_VERSION;
            VIEW_DISTANCE = "20";
            WHITELIST_FILE = "/extras/whitelist.json";
          };
          environmentFiles = [config.sops.secrets."rcon_web_admin_env".path];
          volumes = [
            "/srv/minecraft/${SERVER_NAME_SLUG}-data:/data:rw"
            "${MODS_FILE_PATH}:/extras/mods.txt:ro"
            "${WHITELIST_FILE_PATH}:/extras/whitelist.json:ro"
          ];
          ports = [
            "25565:25565/tcp"
            "25575:25575/tcp"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=${SERVER_NAME_SLUG}"
            "--network=${SERVER_NAME_SLUG}_default"
          ];
        };
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
        # Aborts restarts of service fails 2 times in under 5 minutes
        startLimitIntervalSec = 300; # 5 minutes
        startLimitBurst = 2;
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
