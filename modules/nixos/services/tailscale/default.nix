{
  pkgs,
  lib,
  config,
  ...
}:
let
  authKey = "$(${pkgs.coreutils}/bin/cat ${
    config.sops.secrets."tailscale_auth_keys/client_secret".path
  } | ${pkgs.findutils}/bin/xargs)";
  cfg = config.my.services.tailscale;
in
{
  options.my.services.tailscale = with lib; {
    enable = mkEnableOption "Tailscale";
    autoAuthenticate = mkEnableOption "Automatically authenticate new devices to Tailscale";
    configureFirewall = my.mkDisableOption "Configure firewall for tailscale";
    enableExitNode = mkEnableOption "Enable exit node for this machine";
    useRoutingFeatures = mkOption {
      type =
        with types;
        enum [
          "client"
          "server"
          "both"
        ];
      default = "client";
      description = "See `services.tailscale.useRoutingFeatures`";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # make the tailscale command usable to users
        environment.systemPackages = [ pkgs.tailscale ];
        services.tailscale.enable = true;
      }
      (lib.mkIf cfg.autoAuthenticate {
        # create a oneshot job to authenticate to Tailscale
        systemd.services."tailscale-authenticate" = {
          enable = true;
          description = "Automatically authenticate new devices to Tailscale";
          path = [
            pkgs.tailscale
            pkgs.jq
          ];

          # make sure tailscale is running before trying to authenticate our device
          after = [
            "network-pre.target"
            "tailscale.service"
          ];
          wants = [
            "network-pre.target"
            "tailscale.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            # set this service as a oneshot job
            Type = "oneshot";
          };
          startLimitIntervalSec = 30;
          startLimitBurst = 2;

          # have the job run this shell script
          script =
            let
              tailscale = lib.getExe pkgs.tailscale;
              jq = lib.getExe pkgs.jq;
            in
            ''
              set -x
              # wait for tailscaled to settle
              sleep 6

              # check if we are already authenticated to tailscale
              status="$(${tailscale} status -json | ${jq} -r .BackendState)"
              if [ "$status" = "Running" ]; then # if so, then do nothing
                exit 0
              fi

              # otherwise authenticate with tailscale
              ${tailscale} up \
                --auth-key="${authKey}?ephemeral=false&preauthorized=true" \
                --advertise-tags="tag:nixos" \
                --accept-risk="lose-ssh" \
                --ssh=true \
                ${lib.strings.optionalString cfg.enableExitNode "--advertise-exit-node"}
            '';
        };
      })
      (lib.mkIf cfg.configureFirewall {
        networking.firewall = {
          # enable the firewall
          enable = lib.mkDefault true;

          # always allow traffic from your Tailscale network
          trustedInterfaces = [ "tailscale0" ];

          # allow the Tailscale UDP port through the firewall
          allowedUDPPorts = [ config.services.tailscale.port ];

          #  Do not filter DHCP packets.
          checkReversePath = false;
        };
      })

      (lib.mkIf cfg.enableExitNode {
        # If internet stops working:
        #networking.firewall.checkReversePath = "loose";
        services = {
          tailscale = { inherit (cfg) useRoutingFeatures; };
          # https://github.com/tailscale/tailscale/issues/4254#issuecomment-1075318898
          resolved.enable = true;
        };
      })

      (lib.mkIf cfg.enableExitNode {
        # If internet stops working:
        #networking.firewall.checkReversePath = "loose";
        services = {
          tailscale = {
            inherit (cfg) useRoutingFeatures;
            # Tailscale Exit Nodes expect a powerful modern CPU, this could hammer your CPU with enough traffic!
            #interfaceName = lib.mkIf cfg.enableExitNode "userspace-networking";
          };

          # https://github.com/tailscale/tailscale/issues/4254#issuecomment-1075318898
          resolved.enable = true;

          # https://discourse.nixos.org/t/nixos-tailscale-exit-node-issue/57695/2
          # Set Tailscale UDP as they do not stick and I have not figured out how to make ethtool settings stick.
          networkd-dispatcher = {
            enable = false; # if exitnode

            rules."50-tailscale" = {
              onState = [ "routable" ];
              # We can dynamically retrieve the network interface name that is used to reach 8.8.8.8.
              # $(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
              # Equals "wlp6s0" or "enp5s0" on my system depending on wifi or ethernet connection
              script =
                let
                  ethtool = lib.getExe pkgs.ethtool;
                  ip = lib.getExe' pkgs.iproute2 "ip";
                  cut = lib.getExe' pkgs.toybox "cut";
                in
                ''
                  ${ethtool} -K "$(${ip} -o route get 8.8.8.8 | ${cut} -f 5 -d " ")" rx-udp-gro-forwarding on rx-gro-list off
                '';
            };
          };
        };

        environment.systemPackages = with pkgs; [
          ethtool
          networkd-dispatcher
        ];
      })
    ]
  );
}
