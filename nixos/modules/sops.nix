{
  flake,
  config,
  ...
}: let
  inherit
    (flake.config.people)
    user0
    ;
in {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = false;
    gnupg = {
      # Configured with root gnugpg dir, see: https://github.com/Mic92/sops-nix#use-with-gpg-instead-of-ssh-keys

      # Sops needs acess to the keys before the persist dirs are even mounted; so
      # just persisting the keys won't work, we must point at /persist
      home = "/persist/var/lib/sops";

      # disable importing host ssh keys
      sshKeyPaths = [];
    };
    age.generateKey = false;
    templates = {
      "firefox-syncserver.env".content = ''
        SYNC_MASTER_SECRET=${config.sops.placeholder."firefox_syncserver_secret/${user0}"};
      '';
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
      "firefox_syncserver_secret/${user0}" = {
        mode = "400";
      };
    };
  };
}
