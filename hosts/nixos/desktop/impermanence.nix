{
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
  # zfs import -f zpool-${hostName}
  /*
     boot.initrd.postResumeCommands = lib.mkAfter ''
    zfs rollback -r zpool-${hostName}/local/root@blank
  '';
  */
}
