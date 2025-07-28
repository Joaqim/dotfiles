{
  config,
  lib,
  ...
}:
let
  cfg = config.my.profiles.laptop;
in
{
  options.my.profiles.laptop = with lib; {
    enable = mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable {
    # Enable touchpad support
    services.libinput.enable = true;
    my = {
      # Enable TLP power management
      services.tlp.enable = true;

      # Enable upower power management
      hardware.upower.enable = true;

      # Enable battery notifications
      home.power-alert.enable = true;
    };
  };
}
