# Auto-generated using compose2nix v0.2.1-pre.
{
  pkgs,
  lib,
  ...
}: let
  MINECRAFT_VERSION = "1.20.1";
  MODPACK_VERSION = "v28";
  MODPACK_NAME = "Better Minecraft Modpack";
  MODPACK_NAME_SLUG = lib.strings.toLower (lib.strings.sanitizeDerivationName MODPACK_NAME);

  MODS_FILE_TXT = builtins.toFile "mods.txt" ''
    https://mediafilez.forgecdn.net/files/5029/396/aether_delight_1.0.0_forge_1.20.1.jar
    https://mediafilez.forgecdn.net/files/5052/580/quark_delight_1.0.0_forge_1.20.1.jar
    https://mediafilez.forgecdn.net/files/4760/462/endersdelight-1.20.1-1.0.3.jar
    https://mediafilez.forgecdn.net/files/5257/897/ftb-xmod-compat-forge-2.1.1.jar
    https://mediafilez.forgecdn.net/files/5364/190/ftb-library-forge-2001.2.2.jar
    https://mediafilez.forgecdn.net/files/5378/300/ftb-quests-forge-2001.4.5.jar
    https://mediafilez.forgecdn.net/files/4768/252/umbral_skies-1.3.jar
    https://cdn.modrinth.com/data/d6cSefpO/versions/aIcJkUxQ/twilightdelight-2.0.11.jar
    https://mediafilez.forgecdn.net/files/5267/190/ftb-teams-forge-2001.3.0.jar

    # https://www.curseforge.com/minecraft/mc-mods/mowzies-mobs
    https://mediafilez.forgecdn.net/files/5399/941/mowziesmobs-1.6.5.jar

    # https://modrinth.com/mod/endless-biomes
    https://cdn.modrinth.com/data/pzR01ieE/versions/BE83J8T2/EndlessBiomes%201.5.2s%20-%201.20.1.jar

    #https://mediafilez.forgecdn.net/files/5468/648/twilightforest-1.20.1-4.3.2508-universal.jar

    # https://modrinth.com/mod/starter-kit
    https://cdn.modrinth.com/data/6L3ydNi8/versions/pb3dtXM1/starterkit-1.20.1-7.0.jar
    # and its dependency:
    https://cdn.modrinth.com/data/e0M1UDsY/versions/CACoN3MX/collective-1.20.1-7.74.jar
  '';
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
      containers."rcon-web-admin" = {
        image = "itzg/rcon";
        environment = {
          RWA_USERNAME = "admin";
          RWA_PASSWORD = "admin";
          RWA_RCON_HOST = "${MODPACK_NAME_SLUG}";

          RWA_RCON_PASSWORD = "hunter2";
        };
        ports = [
          "4326:4326"
          "4327:4327"
        ];
        extraOptions = [
          "--network-alias=rcon-web-admin"
          "--network=${MODPACK_NAME_SLUG}_default"
        ];
      };

      containers."${MODPACK_NAME_SLUG}" = {
        image = "itzg/minecraft-server:java21-graalvm";
        environment = {
          ALLOW_FLIGHT = "TRUE";
          DEBUG = "FALSE";
          DIFFICULTY = "easy";
          EULA = "TRUE";
          LEVEL = "${MODPACK_NAME} World 1";
          MAX_PLAYERS = "10";
          MEMORY = "16G";

          ENABLE_AUTOPAUSE = "TRUE";
          MAX_TICK_TIME = "-1";
          # More aggressive settings for demo purposes
          AUTOPAUSE_TIMEOUT_INIT = "600"; # 10 Minutes
          AUTOPAUSE_TIMEOUT_EST = "3600"; # 1 Hour

          TYPE = "MODRINTH";
          MODRINTH_MODPACK = "better-mc-forge-bmc4";
          MODRINTH_VERSION = MODPACK_VERSION;
          MODRINTH_OVERRIDES_EXCLUSIONS = ''
            mods/NekosEnchantedBooks-*.jar
            mods/citresewn-*.jar
            mods/YungsMenuTweaks*.jar
          '';
          MODS_FILE = "/extras/mods.txt";

          MOTD = "Running `${MODPACK_NAME}` version ${MODPACK_VERSION}";
          ONLINE_MODE = "FALSE";
          RCON_PASSWORD = "admin";
          SEED = "8016074285773694051";
          SERVER_NAME = MODPACK_NAME;
          SNOOPER_ENABLED = "FALSE";
          SPAWN_PROTECTION = "0";
          TZ = "Europe/Stockholm";
          USE_AIKAR_FLAGS = "TRUE";
          VERSION = MINECRAFT_VERSION;
          VIEW_DISTANCE = "15";
          WHITELIST = "TRUE";
        };
        volumes = [
          "/srv/minecraft/${MODPACK_NAME_SLUG}-data:/data:rw"
          "${MODS_FILE_TXT}:/extras/mods.txt:ro"
        ];
        ports = [
          "25565:25565/tcp"
        ];
        log-driver = "journald";
        extraOptions = [
          "--network-alias=${MODPACK_NAME_SLUG}"
          "--network=${MODPACK_NAME_SLUG}_default"
        ];
      };
    };
  };
  systemd = {
    services = let
      service = "docker-network-${MODPACK_NAME_SLUG}_default.service";
      target = "docker-compose-${MODPACK_NAME_SLUG}-root.target";
    in {
      "docker-${MODPACK_NAME_SLUG}" = {
        serviceConfig = {
          Restart = lib.mkOverride 500 "no";
        };
        #restartIfChanged = true;

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
      "docker-network-${MODPACK_NAME_SLUG}_default" = {
        path = [pkgs.docker];
        restartIfChanged = true;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "docker network rm -f ${MODPACK_NAME_SLUG}_default";
        };
        script = ''
          docker network inspect ${MODPACK_NAME_SLUG}_default || docker network create ${MODPACK_NAME_SLUG}_default
        '';
        partOf = [target];
        wantedBy = [target];
      };
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    targets."docker-compose-${MODPACK_NAME_SLUG}-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      #wantedBy = ["multi-user.target"];
    };
  };
}
