{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      acpi
      brightnessctl
      cryptsetup
      ffmpeg
      file
      flac
      gvfs
      hardinfo
      just
      ncdu
      neofetch
      nyancat
      p7zip
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
      wtwitch
      xdotool
      zip
      ;
  };
}
