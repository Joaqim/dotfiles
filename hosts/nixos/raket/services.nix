{lib, ...}: {
  my.services = {
    atuin-server.enable = false;
    fail2ban.enable = true;
    ssh-server.enable = true;
    sunshine.enable = true;
    tailscale = {
      enable = true;
      # We shouldn't ever need to reauthenticate on persistent systems
      autoAuthenticate = lib.mkDefault false;
    };
  };
}
