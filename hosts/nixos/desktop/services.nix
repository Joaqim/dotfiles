{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.sops) templates;
  inherit (inputs.ccc.packages."x86_64-linux") ccc;
in
{
  my.services = {
    atuin-server.enable = true;
    earlyoom.enable = true;
    fail2ban.enable = true;
    github-runner.enable = true;
    jellyfin.enable = true;
    nix-cache = {
      enable = true;
      harmonia = {
        secretKeyFile = config.sops.secrets."private_key/cache-desktop-org".path;
        ipAddress = "0.0.0.0"; # Only allow VPN access to cache
        listenPort = 8189;
      };
      atticd = {
        enable = true;
        secretKeyFile = templates."atticd.env".path;
        ipAddress = "0.0.0.0"; # Only allow VPN access to cache
        listenPort = 8190;
        apiEndpoint = "http://desktop:8190/";
      };
    };
    ssh-server.enable = true;
    tailscale = {
      enable = true;
      # We shouldn't ever need to reauthenticate on persistent systems
      autoAuthenticate = lib.mkForce false;
      enableExitNode = true;
      useRoutingFeatures = "server";
    };
    xserver.enable = true;
  };

  systemd.services."ccc" = {
    enable = true;
    restartIfChanged = true;
    after = [ "docker-minecraft-server.service" ];
    wants = [ "docker-minecraft-server.service" ];
    path = [
      pkgs.tailscale
      pkgs.docker
      ccc
    ];
    script = ''
      set -ex
      export PORT=8081
      tailscale serve --yes $PORT &>/dev/null &
      ccc
    '';
  };
}
