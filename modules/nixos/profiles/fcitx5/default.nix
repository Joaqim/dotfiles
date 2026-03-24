{
  config,
  lib,
  pkgs,
  inputs,
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
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = [
          inputs.jqpkgs.packages.${pkgs.stdenv.hostPlatform.system}.fcitx5-jqwerty
        ];

        ignoreUserConfig = true;

        settings = {
          globalOptions = {
            Behaviour = {
              CustomXkbOption = "caps:escape";
              EnableAddons = "jqwerty";
            };
          };
        };
      };
    };
    my.home.gtk.useFcitx5 = true;
  };
}
