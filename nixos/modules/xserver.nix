{lib, ...}: {
  services = {
    xserver = {
      enable = true;
      xkb = lib.mkDefault {
        layout = "us,se";
        variant = "dvp,";
        options = "caps:escape";
      };
    };
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
  console.useXkbConfig = true;
}
