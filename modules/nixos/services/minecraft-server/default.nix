{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.services.minecraft-server;

  DEFAULT_MINECRAFT_VERSION = "1.21.4";
  DEFAULT_SERVER_NAME = "Minecraft Server";
  DEFAULT_SERVER_DATA_DIR = "/srv/minecraft/";
  toStringBool = b: if b then "TRUE" else "FALSE";
in
{
  options.my.services.minecraft-server = with lib; {
    enable = mkEnableOption "Minecraft Server";

    levelName = mkOption {
      type = types.str;
      default = "${DEFAULT_SERVER_NAME} World 1";
    };

    minecraftVersion = mkOption {
      type = types.str;
      default = DEFAULT_MINECRAFT_VERSION;
      description = "Minecraft version";
    };

    modrinthModpack = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    modrinthModpackRemote = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    modpackName = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    motd = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    enableRconWebAdmin = mkEnableOption "enable rcon-web-admin";
    rconWebAdminEnvironmentFilePath = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    resourcePack = {
      url = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "https://cdn.modrinth.com/data/50dA9Sha/versions/hPLOoHUN/FreshAnimations_v1.9.3.zip";
      };
      sha1 = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "a7a9f528a5f6e7c7b14ad70b514ecba89b982cde";
      };
      force = mkEnableOption "force resource pack download for clients";
    };

    # TODO: Assert directory exists and is write permissible
    serverDataDirectory = mkOption {
      type = types.str;
      default = DEFAULT_SERVER_DATA_DIR;
    };

    serverIcon = mkOption {
      type = types.str;
      default = DEFAULT_SERVER_ICON;
    };

    serverName = mkOption {
      type = types.str;
      default = DEFAULT_SERVER_NAME;
    };

    timeZone = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "America/New_York";
    };

    whiteList = mkOption {
      type = with types; nullOr (listOf str);
      default = null;
      example = [
        "Steve"
        "Alice"
        "b2d2d2d2-1111-1111-1111-111111111111"
      ];
      description = "A list of usernames and/or UUIDs";
    };

    whiteListFilePath = mkOption {
      type = with types; nullOr str;
      default = null;
      example = literalExample ''
        builtins.toFile "whitelist.json" builtins.toJSON [
          {
            name = "Steve";
            uuid = "b5d2d2d2-1111-1111-1111-111111111111";
          }
        ]
      '';
    };
  };

  config =
    let
      SERVER_NAME_SLUG = lib.strings.toLower (lib.strings.sanitizeDerivationName cfg.serverName);
      SERVER_DATA_DIR = "${cfg.serverDataDirectory}/${SERVER_NAME_SLUG}-data";

      LEVEL = if cfg.levelName != null then cfg.levelName else "${cfg.serverName} World 1";

      MODRINTH_MODPACK =
        if (cfg.modrinthModpack != null) then
          "/extras/modpack.mrpack"
        else
          toString cfg.modrinthModpackRemote;

      RESOURCE_PACK = toString cfg.resourcePack.url;
      RESOURCE_PACK_ENFORCE = toStringBool cfg.resourcePack.force;
      RESOURCE_PACK_SHA1 = toString cfg.resourcePack.sha1;

      WHITELIST = lib.strings.optionalString (cfg.whiteList != null) (
        lib.concatStringsSep "," cfg.whiteList
      );
      WHITELIST_FILE =
        if (cfg.whiteListFilePath != null) then "/extras/whitelist.json" else "/data/whitelist.json";

      ENABLE_WHITELIST = toStringBool (cfg.whiteList != null || cfg.whiteListFilePath != null);

      MODS_FILE_PATH = builtins.toFile "mods.txt" '''';
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          assertions = [
            {
              assertion = config.virtualisation.docker.enable -> true;

              message = ''
                enabling `my.services.minecraft-server.enable` needs to have
                `virtualisation.docker.enable` enabled.
              '';
            }
            {
              assertion = cfg.whiteList != null -> cfg.whiteListFilePath == null;

              message = ''
                `config.my.services.minecraft-server.whiteList` requires
                `config.my.services.minecraft-server.whiteListFilePath` to be unset.
              '';
            }
            {
              assertion = cfg.whiteListFilePath != null -> cfg.whiteList == null;

              message = ''
                `config.my.services.minecraft-server.whiteListFilePath` requires
                `config.my.services.minecraft-server.whiteList` to be unset.
              '';
            }
            {
              # TODO: The file needs to be valid json, minimally: `[]`
              assertion = cfg.whiteList != null -> builtins.pathExists "${SERVER_DATA_DIR}/whitelist.json";

              message = ''
                `config.my.services.minecraft-server.whiteList` requires
                read-and-writable `${SERVER_DATA_DIR}/whitelist.json` to exist.
              '';
            }
          ];
        }
        {
          virtualisation.oci-containers = {
            backend = "docker";

            containers = {
              "rcon-web-admin" = lib.mkIf cfg.enableRconWebAdmin {
                image = "itzg/rcon";
                # https://github.com/rcon-web-admin/rcon-web-admin#environment-variables
                environment = {
                  RWA_ADMIN = "TRUE"; # Set the initial user as admin
                  RWA_RCON_HOST = SERVER_NAME_SLUG; # See docker container `itzg/minecraft-server`: --network-alias=${SERVER_NAME_SLUG}
                  RWA_SERVER_NAME = cfg.serverName;
                  RWA_WEB_RCON = "TRUE";
                };
                environmentFiles = lib.lists.optional (
                  cfg.rconWebAdminEnvironmentFilePath != null
                ) cfg.rconWebAdminEnvironmentFilePath;
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
                # https://docker-minecraft-server.readthedocs.io/en/latest/variables/
                environment = {
                  inherit
                    ENABLE_WHITELIST
                    LEVEL
                    MODRINTH_MODPACK
                    RESOURCE_PACK
                    RESOURCE_PACK_ENFORCE
                    RESOURCE_PACK_SHA1
                    WHITELIST
                    WHITELIST_FILE
                    ;
                  RCON_PASSWORD = "hunter2";
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

                  MAX_PLAYERS = "10";
                  MAX_TICK_TIME = "-1";
                  MEMORY = "16G";
                  MOTD = toString cfg.motd;
                  MODS_FILE = "/extras/mods.txt";
                  ONLINE_MODE = "FALSE";
                  OP_PERMISSION_LEVEL = "4"; # https://minecraft.fandom.com/wiki/Permission_level#Java_Edition
                  # NOTE: This should only be needed on first world creation
                  RCON_CMDS_STARTUP =
                    lib.strings.optionalString
                      (!(builtins.pathExists "${cfg.serverDataDirectory}/${cfg.levelName}/level.dat"))
                      ''
                        gamerule keepInventory true
                        gamerule mobGriefing false
                        gamerule playersSleepingPercentage 0
                        gamerule doImmediateRespawn true
                        gamerule doInsomnia false
                        gamerule disableElytraMovementCheck true
                      '';
                  SEED = "8016074285773694051";
                  SERVER_NAME = cfg.serverName;
                  SERVER_ICON = cfg.serverIcon;
                  SNOOPER_ENABLED = "FALSE";
                  SPAWN_PROTECTION = "0";
                  TYPE = "MODRINTH";
                  TZ = toString cfg.timeZone;
                  USE_AIKAR_FLAGS = "TRUE";
                  VERSION = cfg.minecraftVersion;
                  VIEW_DISTANCE = "20";
                };
                environmentFiles = lib.lists.optional (
                  cfg.rconWebAdminEnvironmentFilePath != null
                ) cfg.rconWebAdminEnvironmentFilePath;
                volumes = [
                  "${SERVER_DATA_DIR}:/data:rw"
                  "/etc/localtime:/etc/localtime:ro"
                  "/etc/timezone:/etc/timezone:ro"
                  "${MODS_FILE_PATH}:/extras/mods.txt:ro"
                ]
                ++ lib.optional (cfg.whiteListFilePath != null) "${cfg.whiteListFilePath}:${WHITELIST_FILE}:ro"
                ++ lib.optional (MODRINTH_MODPACK != "") "${cfg.modrinthModpack}:${MODRINTH_MODPACK}:ro";
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
        }
        {
          systemd = {
            services =
              let
                service = "docker-network-${SERVER_NAME_SLUG}_default.service";
                target = "docker-compose-${SERVER_NAME_SLUG}-root.target";
              in
              {
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
                  path = [ pkgs.docker ];
                  restartIfChanged = true;
                  serviceConfig = {
                    Type = "oneshot";
                    RemainAfterExit = true;
                    ExecStop = "docker network rm -f ${SERVER_NAME_SLUG}_default";
                  };
                  script = ''
                    docker network inspect ${SERVER_NAME_SLUG}_default || docker network create ${SERVER_NAME_SLUG}_default
                  '';
                  partOf = [ target ];
                  wantedBy = [ target ];
                };
              };
            # Root service
            # When started, this will automatically create all resources and start
            # the containers. When stopped, this will teardown all resources.
            targets."docker-compose-${SERVER_NAME_SLUG}-root" = {
              unitConfig = {
                Description = "Root target generated by compose2nix.";
              };
              wantedBy = [ "multi-user.target" ];
            };
          };
        }
      ]
    );
}
