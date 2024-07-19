{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      cifs-utils
      flameshot
      gparted
      simple-mtpfs
      usbimager
      ;
  };

  xdg.mime.enable = true;
}
