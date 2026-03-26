{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.chimera;
in
{
  options.my.services.chimera = {
    enable = lib.mkEnableOption "Chimera service";

    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = lib.mdDoc ''
        User account under which Chimera runs.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.chimera = {
      enable = true;
      inherit (cfg) user;
    };
  };
}
