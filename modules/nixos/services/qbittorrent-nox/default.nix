{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.services.qbittorrent-nox;
  # Assigned UID and GID when using default "qbittorrent" as user
  UID = 888;
  GID = 888;
  # TODO: Checkout existing: https://github.com/linuxserver/docker-qbittorrent
  # TODO: Add option for login username/password
in
{
  options.my.services.qbittorrent-nox = {
    enable = mkEnableOption (lib.mdDoc "qBittorrent headless");

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/qbittorrent";
      description = lib.mdDoc ''
        The directory where qBittorrent stores its data files.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = lib.mdDoc ''
        User account under which qBittorrent runs.
      '';
    };

    uid = mkOption {
      type = types.uid;
      default = UID;
      description = lib.mdDoc ''
        User ID under which qBittorrent runs.
      '';
    };

    gid = mkOption {
      type = types.gid;
      default = GID;
      description = lib.mdDoc ''
        Group ID under which qBittorrent runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = lib.mdDoc ''
        Group under which qBittorrent runs.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        qBittorrent web UI port.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open services.qBittorrent.port to the outside network.
      '';
    };

    savePath = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/downloads";
      description = lib.mdDoc ''
        The directory where qBittorrent saves downloaded files.
      '';
    };

    noPasswordLocal = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Allow local (0.0.0.0/0) connections to the qBittorrent web UI without a password.
        This is insecure and should only be used in trusted environments.
      '';
    };

    additionalTrackers = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = lib.mdDoc ''
        Additional trackers to append to newly added torrents.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qbittorrent-nox;
      defaultText = literalExpression "pkgs.qbittorrent-nox";
      description = lib.mdDoc ''
        The qbittorrent package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services."qbittorrent-nox" = {
      # based on the plex.nix service module and
      # https://github.com/qbittorrent/qBittorrent/blob/master/dist/unix/systemd/qbittorrent-nox%40.service.in
      description = "qBittorrent-nox service";
      documentation = [ "man:qbittorrent-nox(1)" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Run the pre-start script with full permissions (the "!" prefix) so it
        # can create the data directory if necessary.
        ExecStartPre =
          let
            configFile = pkgs.writeText "qbittorrent.conf" ''
                [BitTorrent]
                Session\AddTorrentStopped=false
                Session\AddTrackersEnabled=true
                Session\AddTrackersFromURLEnabled=true
                Session\AddTrackers=true
                Session\AdditionalTrackers=${lib.concatStringsSep "\\n" cfg.additionalTrackers}
                Session\AdditionalTrackersURL=https://ngosang.github.io/trackerslist/trackers_best.txt
                Session\AlternativeGlobalDLSpeedLimit=100
                Session\AlternativeGlobalUPSpeedLimit=100
                Session\AnonymousModeEnabled=true
                Session\QueueingSystemEnabled=false
                Session\DefaultSavePath=${cfg.savePath}

                # Taken from https://github.com/qBitMF/qBitMF/blob/0454e8b8a9f05b217356cd13469332f08f628b8d/images/qbitmf/qBittorrent.conf.default
                Session\AnnounceToAllTrackers=true
                Session\ConnectionSpeed=300
                Session\HashingThreadsCount=8
                Session\MaxConnections=1000
                Session\MaxConnectionsPerTorrent=2000
                Session\MaxUploads=100
                Session\MaxUploadsPerTorrent=200
                Session\RefreshInterval=500
                Session\SocketBacklogSize=100

                Session\ShareLimitAction=Stop
                Session\StartPaused=false
                Session\Tags=jc141
                Session\UseAlternativeGlobalSpeedLimit=false

                #Session\SSL\Port=41818
                #Session\Port=19756

                #[AddNewTorrentDialog]
                #Enabled=false
                #RememberLastSavePath=true
                #SavePathHistory=${cfg.savePath}

                [LegalNotice]
                Accepted=true

                [Meta]
                MigrationVersion=8

                [Network]
                Cookies=@Invalid()

                [Preferences]
                General\MigrateStatus=true
                Connection\PortRangeMin=6881

                Downloads\SavePath=${cfg.savePath}

                WebUI\Enabled=true
                WebUI\Port=${toString cfg.port}

              ${lib.optionalString cfg.noPasswordLocal ''
                WebUI\AuthSubnetWhitelist=0.0.0.0/0
                WebUI\AuthSubnetWhitelistEnabled=true
                WebUI\UseUPnP=false
                #WebUI\HostHeaderValidation=false # Not sure if needed
              ''}
            '';
            preStartScript = pkgs.writeScript "qbittorrent-run-prestart" ''
              #!${pkgs.bash}/bin/bash
              # Create initial directory structure if it doesn't exist
              if ! test -d "$QBT_PROFILE/qBittorrent/config"; then
                echo "Creating qBittorrent configuration directory structure"
                install -d -m 0755 -o "${cfg.user}" -g "${cfg.group}" "$QBT_PROFILE/qBittorrent/config"
              fi

              # Install declarative config file
              install -m 0644 -o "${cfg.user}" -g "${cfg.group}" "${configFile}" "$QBT_PROFILE/qBittorrent/config/qBittorrent.conf"
            '';
          in
          "!${preStartScript}";

        ExecStart = "${lib.getExe cfg.package} --confirm-legal-notice";
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        Restart = "on-success";
        UMask = "0002";
        #LimitNOFILE = cfg.openFilesLimit;
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_WEBUI_PORT = toString cfg.port;
        QBT_NO_SPLASH = "1";
        QBT_SKIP_DIALOG = "1"; # Skip the dialog when adding a new torrent
      };
    };

    users.users = mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        inherit (cfg) group uid;
      };
    };

    users.groups = mkIf (cfg.group == "qbittorrent") {
      qbittorrent = { inherit (cfg) gid; };
    };
  };
}
