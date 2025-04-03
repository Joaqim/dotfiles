{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.zoxide;
in {
  options.my.home.zoxide = with lib; {
    enable = my.mkDisableOption "enable zoxide";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = config.my.home.nushell.enable;
      options = [
      ];
    };
  };
}
