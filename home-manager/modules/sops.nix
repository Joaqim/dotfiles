{lib, ...}: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = false;
    # NOTE: 2024-11-30, required explicit paths for now: https://discourse.nixos.org/t/access-nixos-sops-secret-via-home-manager/38909/12
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
    gnupg = {
      # Configured with root gnugpg dir, see: https://github.com/Mic92/sops-nix#use-with-gpg-instead-of-ssh-keys

      # Sops needs access to the keys before the persist dirs are even mounted; so
      # just persisting the keys won't work, we must point at /persist
      home = lib.mkDefault "/persist/var/lib/sops";

      # disable importing host ssh keys
      sshKeyPaths = [];
    };
    age.generateKey = false;
    secrets = {
      "steamgrid_db_auth_key" = {
        mode = "400";
      };
    };
  };
}
