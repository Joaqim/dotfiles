{
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
in {
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
      {
        directory = "/etc/ssh";
        user = "root";
        group = "root";
        mode = "u=rwx,g=rx,o=";
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
      {
        directory = "/var/lib/libvirt";
        user = "root";
        group = "libvirtd";
        mode = "u=rwx,g=rwx,o=";
      }
    ];
    files = ["/etc/machine-id"];
  };

  systemd = {
    tmpfiles = {
      rules = [
        "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
        "L /var/lib/acme - - - - /persist/var/lib/acme"
        "L /var/cache/acme - - - - /persist/var/lib/acme"
      ];
    };
  };
  boot = {
    initrd = {
      postDeviceCommands = lib.mkAfter ''
        zpool import zroot-${hostName} ; zfs rollback -r zroot-${hostName}/local/root@blank
      '';
    };
  };
}
