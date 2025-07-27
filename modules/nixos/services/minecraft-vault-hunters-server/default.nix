{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.services.minecraft-vault-hunters-server;

  MINECRAFT_VERSION = "1.18.2";
  MODPACK_NAME = "Vault Hunters";
  MODPACK_VERSION = "3.16.0.1";

  SERVER_ICON_URL = "https://vaulthunters.gg/apple-touch-icon.png";
  SERVER_NAME = "Minecraft ${MODPACK_NAME}";
  SERVER_NAME_SLUG = lib.strings.toLower (lib.strings.sanitizeDerivationName SERVER_NAME);
  SERVER_PORT = "25565";
  WHITELIST_FILE_PATH = config.sops.secrets."minecraft_server_whitelist".path;

  CF_EXCLUDE_MODS = lib.strings.concatStringsSep "," [
    "item-highlighter"
    "iceberg"
  ];

  EXTRA_MODS =
    let
      # Mods in `Vault Hunters` modpack that require manual download
      # Add to nix store with `nix-store --add-fixed sha256 ...`
      neoncraft = pkgs.requireFile {
        name = "neoncraft2-2.2.jar";
        url = "https://www.curseforge.com/minecraft/mc-mods/neon-craft-ultimate/download/3726051";
        hash = "sha256-tva1Xb4h/CjMLoqLB9SLo8FHOBgOvzqEaLU4tRBxUp4=";
      };
      jewel_sorting = pkgs.requireFile {
        name = "vault_hunters_jewel_sorting-2.6.0.jar";
        url = "https://www.curseforge.com/minecraft/mc-mods/vault-hunters-jewel-sorting/download/5585222";
        hash = "sha256-qwIqVi0wB5nIk/fdV4OgFqxdkitny9JZ9rYy09ojKXk=";
      };
      chunky = pkgs.requireFile {
        name = "Chunky-1.2.164.jar";
        url = "https://www.curseforge.com/minecraft/mc-mods/chunky-pregenerator-forge/download/3579662";
        hash = "sha256-1/0ndEeRAaBDWPANdFQSo/gIG//Ph+aVDqUL0yhEQOo=";
      };
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "${SERVER_NAME_SLUG}-downloaded-mods";
      version = "1.0.0";
      srcs = [
        neoncraft
        jewel_sorting
        chunky
      ];
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out
        ln -s ${neoncraft} $out/${neoncraft.name}
        ln -s ${jewel_sorting} $out/${jewel_sorting.name}
        ln -s ${chunky} $out/${chunky.name}
      '';
    };

  # Add list of mods that expect to be downloaded automatically by `itzg/minecraft-server`
  MODS_FILE_PATH = builtins.toFile "mods.txt" '''';
in
{
  options.my.services.minecraft-vault-hunters-server = with lib; {
    enable = mkEnableOption "Minecraft ${MODPACK_NAME} Server";
  };
  config = lib.mkIf cfg.enable {
    # Runtime
    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
      };
      oci-containers = {
        backend = "docker";

        containers = {
          "${SERVER_NAME_SLUG}" = {
            image = "itzg/minecraft-server:java17-graalvm";
            environment = rec {
              inherit SERVER_NAME SERVER_PORT;
              ALLOW_FLIGHT = "TRUE";

              ENABLE_AUTOPAUSE = "TRUE";
              AUTOPAUSE_TIMEOUT_EST = "1200"; # 20 Minutes
              AUTOPAUSE_TIMEOUT_INIT = "600"; # 10 Minutes

              CF_DOWNLOADS_REPO = "/extras/mods";
              CF_SLUG = "vault-hunters-1-18-2";
              CF_FILENAME_MATCHER = MODPACK_VERSION;

              inherit CF_EXCLUDE_MODS;
              # Toggle on when needed: https://github.com/itzg/docker-minecraft-server/issues/3047#issuecomment-2299499005
              #CF_FORCE_SYNCHRONIZE = "TRUE";

              CUSTOM_SERVER_PROPERTIES = ''
                allow-cheats=true
              '';
              DEBUG = "FALSE";
              DIFFICULTY = "easy";

              EULA = "TRUE";
              LEVEL = "${SERVER_NAME} World 1";
              MAX_PLAYERS = "10";
              MAX_TICK_TIME = "-1";
              MEMORY = "8G";
              MODS_FILE = "/extras/mods.txt";
              MOTD = "Running `${MODPACK_NAME}` version ${MODPACK_VERSION}";
              ONLINE_MODE = "FALSE";
              OP_PERMISSION_LEVEL = "4"; # https://minecraft.fandom.com/wiki/Permission_level#Java_Edition
              RCON_CMDS_STARTUP = ''
                gamerule keepInventory true
                gamerule mobGriefing false
                gamerule playersSleepingPercentage 0
                gamerule doImmediateRespawn true
                gamerule doInsomnia false
                gamerule disableElytraMovementCheck true
              '';
              SEED = "010100000100000101000111"; # https://www.reddit.com/r/VaultHuntersMinecraft/comments/z6nlne
              SNOOPER_ENABLED = "FALSE";
              SPAWN_PROTECTION = "0";
              TYPE = "AUTO_CURSEFORGE";
              TZ = "Europe/Stockholm";
              ICON = SERVER_ICON_URL;
              USE_AIKAR_FLAGS = "TRUE";
              VERSION = MINECRAFT_VERSION;
              VIEW_DISTANCE = "20";
              WHITELIST_FILE = "/extras/whitelist.json";
            };
            environmentFiles = [
              config.sops.secrets."rcon_web_admin_env".path
              config.sops.templates."minecraft_CF_API_KEY.env".path
            ];
            volumes = [
              "/srv/minecraft/${SERVER_NAME_SLUG}-data:/data:rw"
              "${MODS_FILE_PATH}:/extras/mods.txt:ro"
              "${WHITELIST_FILE_PATH}:/extras/whitelist.json:ro"
              "${EXTRA_MODS}:/extras/mods:ro"
            ];
            ports = [
              "${SERVER_PORT}:${SERVER_PORT}/tcp"
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
  };
}
