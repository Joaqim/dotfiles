{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.xserver;
in
{
  options.my.services.xserver = with lib; {
    enable = mkEnableOption "Enable X server";

    useXkb = mkEnableOption "use xkb configuration";

    xkbLayout = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    xkbVariant = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    xkbOptions = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion =
              cfg.useXkb -> (cfg.xkbLayout != null || cfg.xkbVariant != null || cfg.xkbOptions != null);
            message = ''
              `config.my.services.xserver.useXkb` requires at least one of
              `config.my.services.xserver.`: `xkbLayout`/`xkbVariant`/`xkbOptions` to be set.
            '';
          }
        ];
      }
      {
        console.useXkbConfig = cfg.useXkb;
        services = {
          xserver = {
            enable = true;
            xkb = lib.mkIf cfg.useXkb {
              layout = cfg.xkbLayout;
              variant = cfg.xkbVariant;
              options = cfg.xkbOptions;
            };
          };
          # TODO: Move to my.profiles.laptop/devices
          libinput = {
            enable = true;
            touchpad = {
              tapping = true;
              naturalScrolling = false;
            };
            mouse = {
              accelProfile = lib.mkDefault "adaptive";
              accelSpeed = lib.mkDefault "0.7";
            };
            touchpad.accelProfile = lib.mkDefault "adaptive";
          };
        };
      }
    ]
  );
}
