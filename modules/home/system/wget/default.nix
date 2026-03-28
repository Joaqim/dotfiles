{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.home.system.wget;
in
{
  options.my.home.system.wget = with lib; {
    enable = my.mkDisableOption "wget configuration";

    package = mkPackageOption pkgs "wget" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    home.sessionVariables = lib.mkIf cfg.enable {
      WGETRC = "${config.xdg.configHome}/wgetrc";
    };

    xdg.configFile."wgetrc".text = ''
      hsts-file = ${config.xdg.stateHome}/wget-hsts
    '';
  };
}
