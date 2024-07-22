# Auto-generated using compose2nix v0.2.1-pre.
{
  pkgs,
  lib,
  ...
}: {
  # Runtime
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers = {
      backend = "docker";

      # Containers
      containers."joaqim-s-minecraft-modpack" = {
        image = "itzg/minecraft-server";
        environment = {
          ALLOW_FLIGHT = "TRUE";
          DEBUG = "FALSE";
          DIFFICULTY = "easy";
          EULA = "TRUE";
          FORGE_VERSION = "47.3.1";
          MEMORY = "16G";
          ONLINE_MODE = "FALSE";
          PACKWIZ_URL = "https://github.com/Joaqim/MinecraftModpack/raw/1.0.1-rc3/pack.toml";
          TYPE = "FORGE";
          TZ = "Europe/Stockholm";
          VERSION = "1.20.1";
          USE_AIKAR_FLAGS = "TRUE";
        };
        volumes = [
          "/srv/joaqim-s-minecraft-modpack-data:/data:rw"
        ];
        ports = [
          "25565:25565/tcp"
        ];
        log-driver = "journald";
        extraOptions = [
          "--network-alias=joaqim-s-minecraft-modpack"
          "--network=joaqim-s-minecraft-modpack_default"
        ];
      };
    };
  };
  systemd = {
    services = let
      service = "docker-network-joaqim-s-minecraft-modpack_default.service";
      target = "docker-compose-joaqim-s-minecraft-modpack-root.target";
    in {
      "docker-joaqim-s-minecraft-modpack" = {
        serviceConfig = {
          Restart = lib.mkOverride 500 "no";
        };
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
      "docker-network-joaqim-s-minecraft-modpack_default" = {
        path = [pkgs.docker];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "docker network rm -f joaqim-s-minecraft-modpack_default";
        };
        script = ''
          docker network inspect joaqim-s-minecraft-modpack_default || docker network create joaqim-s-minecraft-modpack_default
        '';
        partOf = [target];
        wantedBy = [target];
      };
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    targets."docker-compose-joaqim-s-minecraft-modpack-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
