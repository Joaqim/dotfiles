{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.minecraft-server;
  inherit (config.sops) secrets;

  MINECRAFT_VERSION = "1.21.3";

  SERVER_ICON = "https://github.com/Joaqim/MinecraftModpack/blob/main/icon.jpeg?raw=true";
  SERVER_NAME = "Minecraft Server";

  MODPACK_PKG = pkgs.jqpkgs.minecraft-modpack;
in {
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
    environment.systemPackages = [MODPACK_PKG];

    my.services.minecraft-server = let
      MODPACK_NAME = MODPACK_PKG.modpackName;
      MODPACK_VERSION = MODPACK_PKG.modpackVersion;
    in {
      enable = true;

      minecraftVersion = MINECRAFT_VERSION;
      modrinthModpack = "/run/current-system/sw/share/minecraft-modpacks/${MODPACK_PKG.modpack}";
      modpackName = MODPACK_NAME;

      motd = "Running `${MODPACK_NAME}` version: ${MODPACK_VERSION}";

      resourcePack = {
        url = "https://cdn.modrinth.com/data/50dA9Sha/versions/hPLOoHUN/FreshAnimations_v1.9.3.zip";
        sha1 = "a7a9f528a5f6e7c7b14ad70b514ecba89b982cde";
        force = true;
      };

      serverIcon = SERVER_ICON;
      serverName = SERVER_NAME;
      rconWebAdminEnvironmentFilePath = secrets."rcon_web_admin_env".path;
      whiteListFilePath = secrets."minecraft_server_whitelist".path;
    };
  };
}
