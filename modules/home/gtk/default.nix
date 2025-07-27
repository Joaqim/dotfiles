{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.gtk;
in
{
  options.my.home.gtk = with lib; {
    enable = mkEnableOption "GTK configuration";
    useFcitx5 = mkEnableOption "use fcitx5 module";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        gtk = {
          enable = true;

          cursorTheme = {
            name = "catppuccin-macchiato-dark-cursors";
            package = pkgs.catppuccin-cursors.macchiatoDark;
          };

          iconTheme = {
            package = pkgs.catppuccin-papirus-folders.override {
              flavor = "macchiato";
              accent = "mauve";
            };
            name = "Papirus-Dark";
          };

          theme = {
            package = pkgs.catppuccin-gtk.override {
              accents = [ "mauve" ];
              size = "standard";
              variant = "macchiato";
            };
            name = "catppuccin-macchiato-mauve-standard";
          };

          font = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Sans";
          };
          # Cleanup HOME
          gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        };
      }
      (lib.mkIf cfg.useFcitx5 {
        gtk = {
          # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
          gtk2.extraConfig = ''
            gtk-im-module="fcitx";
          '';
          gtk3.extraConfig.gtk-im-module = "fcitx";
          gtk4.extraConfig.gtk-im-module = "fcitx";
        };
      })
      (lib.mkIf config.my.home.xdg.enable {
        xdg.portal = {
          enable = true;
          configPackages = [ pkgs.xdg-desktop-portal-gtk ];
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
        };
      })
    ]
  );
}
