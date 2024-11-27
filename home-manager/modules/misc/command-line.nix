{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      acpi
      brightnessctl
      file
      flac
      gvfs
      hardinfo
      just
      ncdu
      neofetch
      p7zip
      pciutils
      pinentry
      playerctl
      systemctl-tui
      tomb
      unrar
      unzip
      wget
      zip
      ;
  };
}
