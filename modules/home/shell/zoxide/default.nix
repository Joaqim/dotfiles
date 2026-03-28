{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.shell.zoxide;
in
{
  options.my.home.shell.zoxide = with lib; {
    enable = my.mkDisableOption "enable zoxide";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = config.my.home.shell.nushell.enable;
      options = [
      ];
    };
  };
}
