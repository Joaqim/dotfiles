{
  config,
  lib,
  ...
}:
let
  cfg = config.my.profiles.minecraft-server-lucky-world-invasion;
  inherit (config) sops;

  MINECRAFT_VERSION = "1.20.1";

  SERVER_ICON = "https://media.forgecdn.net/attachments/931/680/logo.png";
  SERVER_NAME = "Minecraft Server Lucky World Invasion";

in
{
  options.my.profiles.minecraft-server-lucky-world-invasion = with lib; {
    enable = mkEnableOption "minecraft server with Lucky World Invasion Modpack";
  };

  config = lib.mkIf cfg.enable {
    # Enable docker virtualization
    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
      };
    };

    my.services.minecraft-server =
      let
        MODPACK_NAME = "Lucky World Invasion";
        MODPACK_VERSION = "2.7.2";
      in
      {
        enable = true;

        minecraftVersion = MINECRAFT_VERSION;
        curseForgeSlug = "lucky-world-invasion";
        curseForgeFilenameMatcher = "${MODPACK_VERSION}";
        # TODO:
        #curseForgeAPIKeyFile = sops.templates."minecraft_CF_API_KEY.env".path;
        curseForgeExcludeMods = [
          "nolijium"
        ];
        curseForgeIncludeMods = [
          "particular-reforged"
        ];
        modpackName = MODPACK_NAME;
        levelName = "${SERVER_NAME} World 2026-01-24";

        motd = "Running `${MODPACK_NAME}` version: ${MODPACK_VERSION}";
        timeZone = "Europe/Stockholm";

        serverIcon = SERVER_ICON;
        serverName = SERVER_NAME;
        # Used by minecraft-server:    https://docker-minecraft-server.readthedocs.io/en/latest/variables/#rcon
        # Also used by rcon-web-admin: https://github.com/rcon-web-admin/rcon-web-admin#environment-variables
        # See: https://hub.docker.com/r/itzg/rcon/
        # Expects same value set for RWA_RCON_PASSWORD (rcon-web-admin container) and RCON_PASSWORD (minecraft-server container)
        # RWA_PASSWORD for rcon-web-admin web ui login, with default username RWA_USERNAME="admin"
        rconWebAdminEnvironmentFilePath = sops.secrets."rcon_web_admin_env".path;

        # For now, disable whitelist since users are connected via private network
        #whiteListFilePath = secrets."minecraft_server_whitelist".path;
      };
  };
}
