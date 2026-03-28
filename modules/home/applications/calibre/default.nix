{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.applications.calibre;
in
{
  options.my.home.applications.calibre = with lib; {
    enable = mkEnableOption "calibre configuration";

    package = mkPackageOption pkgs "calibre" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
}
