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
        group = "wheel";
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
  };

  systemd = {
    tmpfiles = {
      rules = [
        "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
        "L /var/lib/acme - - - - /persist/var/lib/acme"
      ];
    };
  };
  /*
      TODO: Make sure we don't lose anything important in /home
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs import zpool ; zfs rollback -r zpool/local/root@blank
  '';
  */
}
