{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.my.secrets;

  user0 = "jq";
  user1 = "deck";
  owner = config.my.user.name;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.my.secrets = with lib; {
    enable = my.mkDisableOption "secrets configuration";
    sopsDirectory = mkOption {
      type = types.str;
      # Sops needs access to the keys before the persist dirs are even mounted; so
      # just persisting the keys won't work, we must point at /persist
      # TODO: Depend on setting of `my.system.impermanence.enable`
      # TODO: Use assertion
      default = "/persist/var/lib/sops";
      example = "/var/lib/sops";
      description = "Directory of gnupg directory used by sops";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create a group that should have access to /var/lib/sops
    users.groups.keys = { };

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      validateSopsFiles = false;
      gnupg = {
        # Configured with root gnugpg dir, see: https://github.com/Mic92/sops-nix#use-with-gpg-instead-of-ssh-keys

        home = cfg.sopsDirectory;

        # disable importing host ssh keys
        sshKeyPaths = [ ];
      };
      age.generateKey = false;
      templates = {
        "firefox-syncserver.env" = {
          content = ''
            SYNC_MASTER_SECRET=${config.sops.placeholder."firefox_syncserver_secret/${user0}"};
          '';
          inherit owner;
        };
        "minecraft_CF_API_KEY.env" = {
          content = ''
            CF_API_KEY=${config.sops.placeholder."minecraft_CF_API_KEY"}
          '';
          inherit owner;
          mode = "400";
        };
        "atticd.env" = {
          content = ''
            ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=${config.sops.placeholder."atticd_server_token"}
          '';
          group = lib.mkIf (builtins.hasAttr "atticd" config.users.groups) "atticd";
          mode = "440";
        };
      };
      secrets = {
        "atticd_server_token" = { };
        "atuin_key/${user0}" = {
          path = "/home/${user0}/.local/share/atuin/key";
          inherit owner;
        };
        "github_token/github-runner-desktop" = {
          inherit owner;
        };
        "private_key/${user0}" = {
          path = "/home/${user0}/.ssh/id_ed25519";
          inherit owner;
        };
        "public_key/${user0}" = {
          path = "/home/${user0}/.ssh/id_ed25519.pub";
          inherit owner;
        };
        "private_key/jq-${user1}" = {
          path = "/home/${user0}/.ssh/id_jq-${user1}";
          inherit owner;
        };
        "public_key/jq-${user1}" = {
          path = "/home/${user0}/.ssh/id_jq-${user1}.pub";
          inherit owner;
        };
        "private_key/jq-ci-bot" = {
          path = "/home/${user0}/.ssh/id_joaqim-ci-bot";
          inherit owner;
        };
        "public_key/jq-ci-bot" = {
          path = "/home/${user0}/.ssh/id_joaqim-ci-bot.pub";
          inherit owner;
        };
        "private_key/cache-desktop-org" = { };
        "public_key/cache-desktop-org" = { };
        "wakatime_api_key/${user0}" = {
          path = "/home/${user0}/.wakatime/api_key.txt";
          inherit owner;
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
          inherit owner;
        };
        "minecraft_server_whitelist" = {
          mode = "400";
          inherit owner;
        };
        "minecraft_CF_API_KEY" = {
          mode = "400";
          inherit owner;
        };
      };
    };
  };
}
