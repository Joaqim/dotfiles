{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      acpi
      brightnessctl
      cryptsetup
      ffmpeg
      flac
      gvfs
      hardinfo
      just
      ncdu
      neofetch
      nyancat
      pciutils
      pinentry
      playerctl
      systemctl-tui
      tomb
      tuir
      unrar
      unzip
      wezterm
      wget
      wine
      wtwitch
      xdotool
      zip
      ;
  };
}
