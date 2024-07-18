{lib, ...}: {
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/sops-nix"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = ["/etc/machine-id"];

    users.jq = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"

        ".mozilla/firefox/Crash Reports"
        ".mozilla/firefox/Pending Pings"
        ".mozilla/firefox/jq" # Do this for now, until we enable syncstorage-rs

        ".local/share/direnv"
        ".local/share/Steam"

        ".local/share/PrismLauncher"
        ".local/share/Trash"

        ".local/share/baloo"
        ".local/share/dolphin"
        ".local/share/kactivitymanagerd"
        ".local/share/kate"
        ".local/share/klipper"
        ".local/share/konsole"
        ".local/share/kscreen"
        ".local/share/kwalletd"
        ".local/share/kxmlgui5"
        ".local/share/RecentDocuments"
        ".local/share/sddm"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".nixops";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
      ];

      files = [
        ".local/share/krunnerstaterc"
        ".local/share/user-places.xbel"
        ".local/share/user-places.xbel.bak"
        ".local/share/user-places.xbel.tbcache"
      ];
    };
  };
  systemd = {
    tmpfiles = {
      rules = [
        "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
        "L /var/lib/acme - - - - /persist/var/lib/acme"
      ];
    };
  };
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zpool/local/root@blank
  '';
}
