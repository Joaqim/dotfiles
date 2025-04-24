{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.xkb;
in {
  options.my.profiles.xkb = with lib; {
    enable = mkEnableOption "Xkb configuration";

    layout = mkOption {
      type = types.str;
      default = "us";
    };
    secondaryLayout = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    useDvp = mkEnableOption "use dvp keymap";
    switchEscapeCapsLock = my.mkDisableOption "switch escape and caps lock";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.useDvp -> (cfg.layout == "us" || cfg.secondaryLayout == "us");
          message = ''
            The option `useDvp` is only supported with "us" layout for `layout` or `secondaryLayout`
          '';
        }
      ];
    }
    {
      my.services.xserver = rec {
        xkbLayout = builtins.concatStringsSep "," [cfg.layout cfg.secondaryLayout];
        xkbOptions = lib.optionalString cfg.switchEscapeCapsLock "caps:escape";

        xkbVariant = lib.optionalString cfg.useDvp (lib.replaceStrings ["us"] ["dvp"] xkbLayout);
      };
    }
  ]);
}
