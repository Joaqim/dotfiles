{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      acpi
      brightnessctl
      dtrx # Do The Right Extraction
      file
      flac
      gvfs
      hardinfo
      just
      ncdu
      neofetch
      neovim
      p7zip
      pciutils
      pinentry
      playerctl
      systemctl-tui
      tomb
      unrar
      unzip
      usbutils
      wget
      zip
      ;
  };
}
