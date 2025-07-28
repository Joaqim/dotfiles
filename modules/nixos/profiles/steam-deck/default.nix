{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.my.profiles.steam-deck;
in
{
  options.my.profiles.steam-deck = with lib; {
    enable = mkEnableOption "steam deck configuration";
  };

  imports = [
    inputs.jovian.nixosModules.jovian
  ];

  config = lib.mkIf cfg.enable {
    hardware.xpadneo.enable = true;

    jovian = {
      devices.steamdeck.enable = true;
      steam = {
        enable = true;
        autoStart = true;

        user = "deck";
        desktopSession = "plasma";
      };
      decky-loader.enable = true;
    };

    my = {
      hardware = {
        firmware = {
          cpuFlavor = "amd";
          kernelOptimization = true;
        };

        graphics = {
          enable = true;
          gpuFlavor = "amd";
          amd.amdvlk = true;
        };
        sound.pipewire.enable = true;
      };
      profiles.devices = {
        enable = true;
        useExternalDrives = true;
      };
      services = {
        ssh-server.enable = true;
        tailscale = {
          enable = true;
          # We shouldn't ever need to reauthenticate on persistent systems
          autoAuthenticate = lib.mkForce false;
        };
        qbittorrent-nox = {
          enable = true;
          user = "deck";
          group = "users";
          port = 8080;
        };
      };
      # Enable use of my self-hosted cache at `desktop:8189`
      system.nix.cache.selfHosted = true;
    };

    services = {
      xserver.enable = true;
      desktopManager.plasma6.enable = true;
    };
  };
}
