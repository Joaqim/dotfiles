{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.flatpak;
in
{
  options.my.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak application support";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
