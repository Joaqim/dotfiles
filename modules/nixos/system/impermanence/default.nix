{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.my.system.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  options.my.system.impermanence = with lib; {
    enable = mkEnableOption "impermanence configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/ssh"
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/tailscale"
        "/var/lib/libvirt"
        "/var/lib/docker"
        {
          directory = "/var/lib/mysql";
          user = "mysql";
          group = "mysql";
          mode = "u=rwx,g=xr,o=x";
        }
        {
          directory = "/var/lib/postgresql";
          user = "postgres";
          group = "postgres";
          mode = "u=rwx,g=xr,o=x";
        }
        {
          directory = "/var/lib/sddm";
          user = "sddm";
          group = "sddm";
          mode = "u=rwx,g=,o=";
        }
        {
          directory = "/srv/minecraft";
          user = "root";
          group = "wheel";
          mode = "u=rwx,g=rwx,o=";
        }
        {
          directory = "/var/lib/sops";
          user = "root";
          group = "keys";
          mode = "u=rwx,g=rx,o=";
        }
        "/etc/NetworkManager/system-connections"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        "/etc/machine-id"
      ];
    };

    systemd = {
      tmpfiles = {
        rules = [
          "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
          "L /var/lib/acme - - - - /persist/var/lib/acme"
        ];
      };
    };
  };
}
