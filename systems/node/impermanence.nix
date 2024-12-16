{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
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
      /*
         postDeviceCommands = lib.mkAfter ''
        zpool import zroot ; zfs rollback -r zroot/local/root@blank
      '';
      */
    };
  };
}
