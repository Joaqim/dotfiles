{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      cifs-utils
      flameshot
      gparted
      simple-mtpfs
      usbimager
      trash-cli
      neovim
      ripgrep
      ;
  };

  xdg.mime.enable = true;
}
