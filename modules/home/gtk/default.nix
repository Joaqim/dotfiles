{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.gtk;
in {
  options.my.home.gtk = with lib; {
    enable = mkEnableOption "GTK configuration";
  };

  config.gtk = lib.mkIf cfg.enable {
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
        accents = ["mauve"];
        size = "standard";
        variant = "macchiato";
      };
      name = "catppuccin-macchiato-mauve-standard";
    };

    font = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };

    gtk2 = {
      # Cleanup HOME
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
      extraConfig = ''
        gtk-im-module="fcitx";
      '';
    };
    gtk3.extraConfig.gtk-im-module = "fcitx";
    gtk4.extraConfig.gtk-im-module = "fcitx";
  };
}
