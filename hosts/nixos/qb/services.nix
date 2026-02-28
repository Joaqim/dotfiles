{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.ucodenix.nixosModules.default
  ];

  services.ucodenix = {
    enable = true;
    #cpuModelId = "00B40F40"; # TODO: https://github.com/e-tho/ucodenix
  };

  services = {
    flatpak.enable = true;
  };

  my.services = {
    caddy.enable = false;

    earlyoom.enable = true;
    fail2ban.enable = true;
    ssh-server.enable = true;
    tailscale = {
      enable = true;
      autoAuthenticate = lib.mkForce true;
    };
    xserver.enable = true;
  };
}
