{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hardware.bluetooth;
in {
  options.my.hardware.bluetooth = with lib; {
    enable = mkEnableOption "bluetooth configuration";

    enableHeadsetIntegration = my.mkDisableOption "A2DP sink configuration";

    loadExtraCodecs = my.mkDisableOption "extra audio codecs";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Enable bluetooth devices and GUI to connect to them
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {General = {Experimental = true;};};
        disabledPlugins = ["sap"];
      };
      # Plasma KDE provides GUI for connecting Bluetooth devices
      # services.blueman.enable = true;
    }

    # Support for additional bluetooth codecs
    (lib.mkIf cfg.loadExtraCodecs {
      services.pulseaudio = {
        extraModules = [pkgs.pulseaudio-modules-bt];
        package = pkgs.pulseaudioFull;
      };
    })

    # Support for A2DP audio profile
    (lib.mkIf cfg.enableHeadsetIntegration {
      hardware.bluetooth.settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    })
  ]);
}
