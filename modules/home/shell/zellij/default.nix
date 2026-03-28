{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.shell.zellij;
in
{
  options.my.home.shell.zellij = with lib; {
    enable = my.mkDisableOption "enable zellij";
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings.theme = "catppuccin-macchiato";
    };
  };
}
