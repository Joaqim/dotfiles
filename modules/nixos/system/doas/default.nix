{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.system.doas;
in
{
  # TODO:
  # https://github.com/ImYuugen/nixos-config/blob/d4637875b819d06f2a2d01a4803d5cd1233c5737/modules/system/security/doas.nix#L20
  options.my.system.doas = with lib; {
    enable = my.mkDisableOption "doas configuration";
    # A lot of applications break if sudo is missing, i.e `nixos-rebuild --sudo`
    # Could also be provided in home environment or devShells
    useSudoShim = my.mkDisableOption "use sudo shim - recommended, provides pkgs.doas-sudo-shim";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        security = {
          sudo.enable = false;
          doas = {
            enable = true;
            wheelNeedsPassword = false;
            # TODO: This should maybe be defined in `nixos.profiles`, or in a new module in: ${self}/modules/home/doas
            extraRules =
              let
                users = [ config.my.user.name ];
              in
              [
                {
                  inherit users;
                  keepEnv = true;
                  noPass = false;
                  groups = [ "wheel" ];
                  persist = true;
                }
                {
                  inherit users;
                  noPass = true;
                  groups = [ "wheel" ];
                  cmd = "systemctl";
                }
                {
                  inherit users;
                  noPass = true;
                  groups = [ "wheel" ];
                  cmd = "liquidctl";
                }
                {
                  inherit users;
                  noPass = true;
                  groups = [ "wheel" ];
                  cmd = "journalctl";
                }
                {
                  inherit users;
                  noPass = true;
                  groups = [ "wheel" ];
                  cmd = "nixos-rebuild";
                }
              ];
          };
        };
      }

      (lib.mkIf cfg.useSudoShim {
        environment.systemPackages = [ pkgs.doas-sudo-shim ];
      })

    ]
  );
}
