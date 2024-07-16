{ lib, ... }: {
  services = {
    xserver = {
      enable = true;
      xkb = lib.mkDefault {
        layout = "us,se";
        variant = "dvp,";
        options = "caps:swapescape";
      };
    };
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = false;
      };
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "flat";
    };
  };
  console.useXkbConfig = true;
}
