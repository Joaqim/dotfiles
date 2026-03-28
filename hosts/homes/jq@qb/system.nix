{ pkgs, ... }:
{
  my.home.system = {
    documentation.enable = true;
    packages.additionalPackages = builtins.attrValues {
      inherit (pkgs)
        nh
        lm_sensors
        wl-clipboard
        ;
    };
    secrets.enable = true;
  };
}
