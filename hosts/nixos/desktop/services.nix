{
  config,
  lib,
  ...
}: {
  my.services = {
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
    };
  };
}
