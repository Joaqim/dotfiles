{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      evince
      file-roller
      nautilus
      gnome-disk-utility
      gnome-system-monitor
      gnome-tweaks
      gnome-characters
      gnome-remote-desktop
      gnome-shell-extensions
      ;
    inherit
      (pkgs.gnomeExtensions)
      paperwm
      keep-awake
      notification-banner-reloaded
      no-overview
      wallpaper-slideshow
      dash-to-panel
      just-perfection
      appindicator
      tiling-assistant
      start-overlay-in-application-view
      ;
  };
}
