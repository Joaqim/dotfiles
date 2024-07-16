{pkgs, ...}: {
  services.touchegg = {
    enable = true;
    package = pkgs.touchegg;
  };
}
