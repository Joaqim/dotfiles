{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.zerotier;
in
{
  options.my.services.zerotier = with lib; {
    enable = mkEnableOption "Enable zerotier peer configuration";
  };
  config = lib.mkIf cfg.enable {
    services.zerotierone = {
      enable = true;
      # TODO:  Use secrets
      joinNetworks = [ (builtins.getEnv "ZEROTIER_NETWORK_ID") ];
    };
    # Allow VPS peer node.zt to connect via SSH to this host
    programs.ssh.knownHosts = {
      "node.zt" = {
        hostNames = [
          "node.zt"
          "fd76:fc96:e498:7494:cc99:9340:ce7b:4623" # Zerotier IPv6
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrYGQQSNLS/s4wKpzd0PMLkTB/RvsH0C8h0BXQ1WI2f";
      };
    };

  };
}
