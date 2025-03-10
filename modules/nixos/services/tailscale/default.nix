{
  pkgs,
  lib,
  config,
  ...
}: let
  authKey = "$(${pkgs.coreutils}/bin/cat ${config.sops.secrets."tailscale_auth_keys/client_secret".path} | ${pkgs.findutils}/bin/xargs)";
  cfg = config.my.services.tailscale;
in {
  options.my.services.tailscale = with lib; {
    enable = mkEnableOption "Tailscale";
    autoAuthenticate = mkEnableOption "Automatically authenticate new devices to Tailscale";
  };

  config = lib.mkIf cfg.enable {
    # make the tailscale command usable to users
    environment.systemPackages = [pkgs.tailscale];
    services.tailscale.enable = true;

    # create a oneshot job to authenticate to Tailscale
    systemd.services."tailscale-authenticate" = lib.mkIf cfg.autoAuthenticate {
      enable = true;
      description = "Automatically authenticate new devices to Tailscale";
      path = [pkgs.tailscale pkgs.jq];

      # make sure tailscale is running before trying to authenticate our device
      after = ["network-pre.target" "tailscale.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        # set this service as a oneshot job
        Type = "oneshot";
      };
      startLimitIntervalSec = 30;
      startLimitBurst = 2;

      # have the job run this shell script
      script = let
        tailscale = lib.getExe pkgs.tailscale;
        jq = lib.getExe pkgs.jq;
      in ''
        set -x
        # wait for tailscaled to settle
        sleep 6

        # check if we are already authenticated to tailscale
        status="$(${tailscale} status -json | ${jq} -r .BackendState)"
        if [ "$status" = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale
        ${tailscale} up --auth-key="${authKey}?ephemeral=false&preauthorized=true" --advertise-tags="tag:nixos" --accept-risk="lose-ssh" --ssh=true
      '';
    };
    networking.firewall = {
      # enable the firewall
      enable = lib.mkDefault true;

      # always allow traffic from your Tailscale network
      trustedInterfaces = ["tailscale0"];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [config.services.tailscale.port];

      #  Do not filter DHCP packets.
      checkReversePath = false;
    };
  };
}
