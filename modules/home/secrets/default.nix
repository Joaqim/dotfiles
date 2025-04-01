{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.my.home.secrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.my.home.secrets = with lib; {
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
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      validateSopsFiles = false;
      gnupg = {
        # Configured with root gnugpg dir, see: https://github.com/Mic92/sops-nix#use-with-gpg-instead-of-ssh-keys
        home = cfg.sopsDirectory;

        # disable importing host ssh keys
        sshKeyPaths = [];
      };
      age.generateKey = false;
      secrets = {
        "steamgrid_db_auth_key" = {
          path = "%r/steamgrid_db_auth_key.txt";
        };
      };
    };
  };
}
