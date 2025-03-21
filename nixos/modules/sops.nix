{
  flake,
  config,
  lib,
  ...
}: let
  inherit
    (flake.config.people)
    user0
    user1
    ;
in {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = false;
    gnupg = {
      # Configured with root gnugpg dir, see: https://github.com/Mic92/sops-nix#use-with-gpg-instead-of-ssh-keys

      # Sops needs access to the keys before the persist dirs are even mounted; so
      # just persisting the keys won't work, we must point at /persist
      home = lib.mkDefault "/persist/var/lib/sops";

      # disable importing host ssh keys
      sshKeyPaths = [];
    };
    age.generateKey = false;
    templates = {
      "firefox-syncserver.env" = {
        content = ''
          SYNC_MASTER_SECRET=${config.sops.placeholder."firefox_syncserver_secret/${user0}"};
        '';
        owner = user0;
      };
      "minecraft_CF_API_KEY.env" = {
        content = ''
          CF_API_KEY=${config.sops.placeholder."minecraft_CF_API_KEY"}
        '';
        owner = user0;
        mode = "400";
      };
    };
    secrets = {
      "atuin_key/${user0}" = {
        path = "/home/${user0}/.local/share/atuin/key";
        owner = user0;
      };
      "private_key/${user0}" = {
        path = "/home/${user0}/.ssh/id_ed25519";
        owner = user0;
      };
      "public_key/${user0}" = {
        path = "/home/${user0}/.ssh/id_ed25519.pub";
        owner = user0;
      };
      "private_key/jq-${user1}" = {
        path = "/home/${user0}/.ssh/id_jq-${user1}";
        owner = user0;
      };
      "public_key/jq-${user1}" = {
        path = "/home/${user0}/.ssh/id_jq-${user1}.pub";
        owner = user0;
      };
      "private_key/jq-ci-bot" = {
        path = "/home/${user0}/.ssh/id_joaqim-ci-bot";
        owner = user0;
      };
      "public_key/jq-ci-bot" = {
        path = "/home/${user0}/.ssh/id_joaqim-ci-bot.pub";
        owner = user0;
      };
      "wakatime_api_key/${user0}" = {
        path = "/home/${user0}/.wakatime/api_key.txt";
        owner = user0;
        mode = "400";
      };
      "synology/${user0}" = {
        path = "/etc/cifs";
        owner = "root";
        mode = "600";
      };
      "user_hashed_password/${user0}" = {
        neededForUsers = true;
      };
      "tailscale_auth_keys/client_secret" = {
        mode = "400";
      };
      "firefox_syncserver_secret/${user0}" = {
        mode = "400";
      };
      "rcon_web_admin_env" = {
        mode = "400";
        owner = user0;
      };
      "minecraft_server_whitelist" = {
        mode = "400";
        owner = user0;
      };
      "minecraft_CF_API_KEY" = {
        mode = "400";
        owner = user0;
      };
    };
  };
}
