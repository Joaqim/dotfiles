{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.minecraft-server;
  inherit (config.sops) secrets;

  MINECRAFT_VERSION = "1.21.9";

  SERVER_ICON = "https://github.com/Joaqim/MinecraftModpack/blob/main/icon.jpeg?raw=true";
  SERVER_NAME = "Minecraft Server";

  MODPACK_PKG = pkgs.jqpkgs.minecraft-modpack;
in
{
  options.my.profiles.minecraft-server = with lib; {
    enable = mkEnableOption "minecraft server with custom modpack";
  };

  config = lib.mkIf cfg.enable {
    # Enable docker virtualization
    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
      };
    };
    environment.systemPackages = [ MODPACK_PKG ];

    my.services.minecraft-server =
      let
        MODPACK_NAME = MODPACK_PKG.modpackName;
        MODPACK_VERSION = MODPACK_PKG.modpackVersion;
      in
      {
        enable = true;

        minecraftVersion = MINECRAFT_VERSION;
        modrinthModpack = "/run/current-system/sw/share/minecraft-modpacks/${MODPACK_PKG.modpack}";
        modpackName = MODPACK_NAME;
        #levelName = "${SERVER_NAME} World 1";
        levelName = "${SERVER_NAME} World 2025-07-05";

        motd = "Running `${MODPACK_NAME}` version: ${MODPACK_VERSION}";

        resourcePack = {
          url = "https://cdn.modrinth.com/data/50dA9Sha/versions/kJAJJOwD/FreshAnimations_v1.10.2.zip";
          # nix hash file ~/Downloads/FreshAnimations_v1.10.2.zip --type sha1 --base16
          sha1 = "2976d7e921cc8d0bd7643741a95ed31bbe36458b";
          force = true;
        };
        timeZone = "Europe/Stockholm";

        serverIcon = SERVER_ICON;
        serverName = SERVER_NAME;
        # Used by minecraft-server:    https://docker-minecraft-server.readthedocs.io/en/latest/variables/#rcon
        # Also used by rcon-web-admin: https://github.com/rcon-web-admin/rcon-web-admin#environment-variables
        # See: https://hub.docker.com/r/itzg/rcon/
        # Expects same value set for RWA_RCON_PASSWORD (rcon-web-admin container) and RCON_PASSWORD (minecraft-server container)
        # RWA_PASSWORD for rcon-web-admin web ui login, with default username RWA_USERNAME="admin"
        rconWebAdminEnvironmentFilePath = secrets."rcon_web_admin_env".path;

        # For now, disable whitelist since users are connected via private network
        #whiteListFilePath = secrets."minecraft_server_whitelist".path;
      };
  };
}
