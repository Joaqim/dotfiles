{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.cross-seed;
in
{
  options.my.services.cross-seed = {
    enable = lib.mkEnableOption "cross-seed torrent cross-seeding";

    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = lib.mdDoc ''
        User account under which cross-seed runs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = lib.mdDoc ''
        Group under which cross-seed runs.
      '';
    };

    useGenConfigDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = lib.mdDoc ''
        Use generated config defaults.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = lib.mdDoc ''
        Additional settings for cross-seed.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.cross-seed = {
      enable = true;
      inherit (cfg)
        user
        group
        useGenConfigDefaults
        settings
        ;
    };
  };
}
