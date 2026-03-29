{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.fcitx5;
in
{
  options.my.profiles.fcitx5 = with lib; {
    enable = mkEnableOption "fcitx5 configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      FCITX_DEBUG = "*";
    };
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          jqpkgs.fcitx5-jqwerty
        ];

        ignoreUserConfig = true;
        waylandFrontend = true;
        quickPhrase = {
          smile = "（・∀・）";
          angry = "(￣ー￣)";
          yes = ":+1:";
        };

        settings.globalOptions = {
          Behaviour = {
            CustomXkbOption = "caps:escape";
            EnableAddons = "jqwerty";
          };
        };
      };
    };
    my.home.desktop.gtk.useFcitx5 = true;
  };
}
