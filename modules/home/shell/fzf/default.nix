{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.shell.fzf;
in
{
  options.my.home.shell.fzf = with lib; {
    enable = my.mkDisableOption "fzf configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
    };
  };
}
