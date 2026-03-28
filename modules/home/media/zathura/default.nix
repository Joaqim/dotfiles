{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.media.zathura;
in
{
  options.my.home.media.zathura = with lib; {
    enable = mkEnableOption "zathura configuration";
  };

  config.programs.zathura = lib.mkIf cfg.enable {
    enable = true;

    options = {
      # Show '~' instead of full path to '$HOME' in window title
      "window-title-home-tilde" = true;
      # Show '~' instead of full path to '$HOME' in status bar
      "statusbar-home-tilde" = true;
    };
  };
}
