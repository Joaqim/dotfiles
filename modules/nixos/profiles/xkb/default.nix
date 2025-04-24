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
      type = with types; enum ["dvp" "se" "us"];
      default = "dvp";
    };
    secondaryLayout = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    switchEscapeCapsLoc = my.mkDisableOption "switch escape and caps lock";
  };

  config.my.services.xserver = lib.mkIf cfg.enable (lib.mkMerge [
    {
      xkbLayout = "${cfg.layout},${toString cfg.secondaryLayout}";
    }

    (lib.mkIf cfg.switchEscapeCapsLoc {
      xkbOptions = "caps:escape";
    })

    (lib.mkIf
      (cfg.keymap == "dvp")
      {
        xkbVariant = "dvp,";
      })
  ]);
}
