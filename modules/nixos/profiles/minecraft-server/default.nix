{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.profiles.minecraft-server;

  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/Joaqim/MinecraftModpack/raw/refs/tags/v2025.11.22-rc2/pack.toml";
    packHash = "sha256-VPlpir6daMJufcIxulKHlw15J+kXoD8JCnbwX1O/P10=";
  };

  # ── Loader detection ──────────────────────────────────────────────────
  # The loader key as nix-minecraft expects it in pkgs.<loader>Servers
  # e.g. "fabric" → pkgs.fabricServers.fabric-1_21_9

  # Resolve which loader is present.  The spec for both packwiz and modrinth
  # says exactly one of these keys will appear alongside "minecraft".
  loaderMap = {
    "fabric" = "fabric";
    "quilt" = "quilt";
    "forge" = "forge";
    "neoforge" = "neoforge";
  };

  deps = modpack.manifest.versions;

  detectedLoaderKey =
    lib.findFirst (k: deps ? ${k})
      (throw "${modpack.pname}: pack.toml has no recognised loader key in dependencies: ${builtins.toJSON deps}")
      (builtins.attrNames loaderMap);

  loader = loaderMap.${detectedLoaderKey};
  #loaderVersion = deps.${detectedLoaderKey};
  minecraftVersion = deps.minecraft;

  minecraftServerPackage = "${loader}-${lib.replaceStrings [ "." " " ] [ "_" "_" ] minecraftVersion}";
  resourcePack = {
    url = "https://cdn.modrinth.com/data/50dA9Sha/versions/kJAJJOwD/FreshAnimations_v1.10.2.zip";
    # nix hash file ~/Downloads/FreshAnimations_v1.10.2.zip --type sha1 --base16
    sha1 = "2976d7e921cc8d0bd7643741a95ed31bbe36458b";
  };
in
{
  options.my.profiles.minecraft-server = with lib; {
    enable = mkEnableOption "minecraft server with custom modpack";
  };

  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  config = lib.mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      servers = {
        "${lib.strings.sanitizeDerivationName "${modpack.manifest.name} ${modpack.manifest.version}"}" = {
          enable = true;
          package = pkgs."${loader}Servers"."${minecraftServerPackage}".override {
            # TODO: The pack provides Fabric API version in place of Fabric, disabling for now.
            #inherit loaderVersion;
          };
          serverProperties = {
            online-mode = false;
            resource-pack-sha1 = resourcePack.sha1;
          };
          symlinks = {
            "resourcepacks/FreshAnimations_v1.10.2.zip" = pkgs.fetchurl {
              inherit (resourcePack) url sha1;
            };
          };
        };
      };
    };
  };
}
