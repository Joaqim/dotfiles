{
  my.services = {
    atuin.enable = false;
    fail2ban.enable = true;
    ssh-server.enable = true;
    tailscale = {
      enable = true;
      # We shouldn't ever need to reauthenticate on persistent systems
      autoAuthenticate = true;
    };
  };
}
