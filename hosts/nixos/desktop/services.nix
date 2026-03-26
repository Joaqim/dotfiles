{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.sops) templates;
in
{
  my.services = {
    alexandria.enable = true;
    atuin-server.enable = false;
    caddy.enable = false;
    ccc.enable = false;
    cross-seed = {
      enable = false;
      user = config.my.user.name;
      group = "users";
      useGenConfigDefaults = true;
      settings = {
        useClientTorrents = false;
        torrentDir = "/home/${config.my.user.name}/Torrents/";
      };
    };
    earlyoom.enable = true;
    fail2ban.enable = true;
    flatpak.enable = true;
    github-runner.enable = true;
    jellyfin.enable = false;
    komga = {
      enable = false;
      openFirewall = false; # Port: 25600
      group = "users";
      port = 25600;
    };
    nix-cache = {
      enable = true;
      harmonia = {
        secretKeyFile = config.sops.secrets."private_key/cache-desktop-org".path;
        ipAddress = "0.0.0.0"; # Only allow VPN access to cache
        listenPort = 8189;
      };
      atticd = {
        enable = true;
        secretKeyFile = templates."atticd.env".path;
        ipAddress = "0.0.0.0"; # Only allow VPN access to cache
        listenPort = 8190;
        apiEndpoint = "http://desktop:8190/";
      };
    };
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      rocmOverrideGfx = "12.0.1";
      loadModels = [ "gemma3:1b" ];
      environmentVariables = {
        OLLAMA_LOAD_TIMEOUT = "30m";
        # https://www.techpowerup.com/gpu-specs/radeon-rx-6700-xt.c3695
        # AMD Radeon RX 6700 XT - Navi 22
        #HCC_AMDGPU_TARGET = "gfx1031";
        # https://www.techpowerup.com/gpu-specs/radeon-rx-9070-xt.c4229
        # AMD Radeon RX 9070 XT - Navi 48
        HCC_AMDGPU_TARGET = "gfx1201";
        # https://github.com/ollama/ollama/issues/10430#issuecomment-3456372794
        # Use less resources:
        GPU_MAX_HW_QUEUES = "1";
      };
      host = "0.0.0.0";
      # Re-declare default port for convenience
      port = 11434;
    };
    open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 8154;
      environment = {
        # Defaults
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        # Disable authentication
        WEBUI_AUTH = "False";

        # Ollama api
        OLLAMA_API_BASE_URL = "http://desktop:11434";
        OLLAMA_LOAD_TIMEOUT = "30m";

        ## Reduce VRAM usage
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0"; # or q4_0 (more savings, less stable)
      };
    };
    qdrant.enable = true;
    # TODO: Check error when disabling: Failed to stop var-lib-qbittorrent.mount
    qbittorrent-nox = {
      enable = true;
      package = pkgs.qbittorrent-enhanced-nox;
      user = "jq";
      group = "users";
      port = 8989;
      noPasswordLocal = true; # Allow local connections without password

      savePath = "/home/jq/Games/";

      additionalTrackers = [
        "http://0d.kebhana.mx:443/announce"
        "http://highteahop.top:6960/announce"
        "http://open.trackerlist.xyz:80/announce"
        "http://retracker.spark-rostov.ru:80/announce"
        "http://seeders-paradise.org:80/announce"
        "http://tracker.bt-hash.com:80/announce"
        "http://tracker.bz:80/announce"
        "http://tracker.corpscorp.online:80/announce"
        "http://tracker.dmcomic.org:2710/announce"
        "http://tracker.ipv6tracker.org:80/announce"
        "http://tracker.moxing.party:6969/announce"
        "http://tracker.openbittorrent.com:80/announce"
        "http://tracker.vanitycore.co:6969/announce"
        "http://tracker.xiaoduola.xyz:6969/announce"
        "http://www.genesis-sp.org:2710/announce"
        "udp://coppersurfer.tk:6969/announce"
        "udp://discord.heihachi.pw:6969/announce"
        "udp://explodie.org:6969/announce"
        "udp://ns-1.x-fins.com:6969/announce"
        "udp://open.demonii.com:1337/announce"
        "udp://open.stealth.si:80/announce"
        "udp://open.tracker.cl:1337/announce"
        "udp://opentracker.i2p.rocks:6969/announce"
        "udp://opentracker.io:6969/announce"
        "udp://tracker-udp.gbitt.info:80/announce"
        "udp://tracker.internetwarriors.net:1337/announce"
        "udp://tracker.leechers-paradise.org:6969/announce"
        "udp://tracker.ololosh.space:6969/announce"
        "udp://tracker.opentrackr.org:1337/announce"
        "udp://tracker.qu.ax:6969/announce"
        "udp://tracker.tiny-vps.com:6969/announce"
        "udp://tracker.torrent.eu.org:451/announce"
        "udp://tracker.zer0day.to:1337/announce"
      ];
    };
    ssh-server.enable = true;
    sunshine.enable = false;
    tailscale = {
      enable = true;
      # We shouldn't ever need to reauthenticate on persistent systems
      autoAuthenticate = lib.mkForce false;
      enableExitNode = true;
      useRoutingFeatures = "server";
    };
    ucodenix = {
      enable = true;
      cpuModelId = "00B40F40";
    };
    xserver.enable = true;
  };
}
