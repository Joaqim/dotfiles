{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.sops) templates;
  inherit (inputs) jellyfin-plugins;
in {
  imports = [
    jellyfin-plugins.nixosModules.jellyfin-plugins
  ];
  my.services = {
    atticd = {
      enable = true;
      environmentFile = templates."atticd.env".path;
      ipAddress = "0.0.0.0";
      listenPort = 8080;
    };
    atuin-server.enable = true;
    fail2ban.enable = true;
    nix-cache = {
      enable = true;
      secretKeyFile = config.sops.secrets."private_key/cache-desktop-org".path;
      ipAddress = "0.0.0.0"; # Only allow VPN access to cache
    };
    ssh-server.enable = true;
    tailscale = {
      enable = true;
      # We shouldn't ever need to reauthenticate on persistent systems
      autoAuthenticate = lib.mkForce false;
      enableExitNode = true;
      useRoutingFeatures = "server";
    };
  };

  # TODO: move to my.services.jellyfin
  services.jellyfin.enabledPlugins = {
    inherit (jellyfin-plugins.packages."x86_64-linux") ani-sync;
  };
}
