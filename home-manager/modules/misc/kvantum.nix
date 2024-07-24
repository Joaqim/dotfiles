{pkgs, ...}: {
  xdg.configFile = let
    variant = "Mocha";
    accent = "Mauve";
    kvantumThemePackage = pkgs.catppuccin-kvantum.override {
      inherit variant accent;
    };
  in {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-${variant}-${accent}
    '';

    # The important bit is here, links the theme directory from the package to a directory under `~/.config`
    # where Kvantum should find it.
    "Kvantum/Catppuccin-${variant}-${accent}".source = "${kvantumThemePackage}/share/Kvantum/Catppuccin-${variant}-${accent}";
  };
}
