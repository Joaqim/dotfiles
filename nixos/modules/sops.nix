{flake, ...}: let
  inherit
    (flake.config.people)
    user0
    ;
in {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = false;
    gnupg = {
      # root gnugpg dir, see: https://github.com/Mic92/sops-nix#use-with-gpg-instead-of-ssh-keys
      home = "/var/lib/sops";
      # disable importing host ssh keys
      sshKeyPaths = [];
    };
    age.generateKey = false;
    secrets = {
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
    };
  };
}
