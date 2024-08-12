{pkgs, ...}: {
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
      settings = {General = {Experimental = true;};};
      disabledPlugins = ["sap"];
    };
  };
  # Plasma KDE provides GUI for connecting Bluetooth devices
  # services.blueman.enable = true;
}
