{ lib, ... }:
{
  my.services = {
    caddy.enable = false;
    earlyoom.enable = true;
    fail2ban.enable = true;
    flatpak.enable = true;
    ssh-server.enable = true;
    tailscale = {
      enable = true;
      autoAuthenticate = lib.mkForce false;
    };
    ucodenix = {
      enable = true;
      # TODO: Determine CPU model ID - see https://github.com/e-tho/ucodenix
      #cpuModelId = "00000000"; # Placeholder
    };
    xserver.enable = true;
  };
}
