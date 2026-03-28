{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.shell.dircolors;
in
{
  options.my.home.shell.dircolors = with lib; {
    enable = my.mkDisableOption "dircolors configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.dircolors = {
      enable = true;
    };
  };
}
