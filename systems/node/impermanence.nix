{lib, pkgs, ...}: {
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
      /*{
        directory = "/var/lib/sops";
        user = "root";
        group = "keys";
        mode = "700";
      }*/
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
        zfs rollback -r rpool/local/root@blank
      '';
/*       systemd = {
        enable = true;
        services.reset = {
          description = "reset root filesystem";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-system.service" ];
          before = [ "sysroot.mount" ];
          path = with pkgs; [ zfs ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = "zfs rollback -r zroot/local/root@blank";
        };
      }; */
    };
  };
}
