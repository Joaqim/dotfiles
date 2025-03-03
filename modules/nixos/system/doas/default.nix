{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.system.doas;
in {
  options.my.system.doas = with lib; {
    enable = my.mkDisableOption "doas configuration";
    useSudoShim = my.mkDisableOption "use sudo shim";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      security = {
        # TODO: Should `sudo` be enabled?
        sudo.enable = false;
        doas = {
          enable = true;
          wheelNeedsPassword = false;
          # TODO: This should maybe be defined in `nixos.profiles`
          extraRules = let
            users = [config.my.user.name];
          in [
            {
              inherit users;
              keepEnv = true;
              noPass = false;
              persist = true;
            }
            {
              inherit users;
              noPass = true;
              cmd = "systemctl";
            }
            {
              inherit users;
              noPass = true;
              cmd = "liquidctl";
            }
            {
              inherit users;
              noPass = true;
              cmd = "journalctl";
            }
            {
              inherit users;
              noPass = true;
              cmd = "nixos-rebuild";
            }
          ];
        };
      };
    }
    (lib.mkIf
      cfg.useSudoShim
      {
        environment.systemPackages = [pkgs.doas-sudo-shim];
      })
  ]);
}
