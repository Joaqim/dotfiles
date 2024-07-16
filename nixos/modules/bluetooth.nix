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
  # services.blueman.enable = true;
}
