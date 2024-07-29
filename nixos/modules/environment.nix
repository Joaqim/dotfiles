{pkgs, ...}: {
  environment = {
    enableAllTerminfo = true;
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        git
        pijul
        sshfs
        tomb
        virt-manager
        ;
    };
    variables = {
      VIDEO_PLAYER = "mpv";
      EDITOR = "nvim";
      GRIM_DEFAULT_DIR = "$HOME/Pictures/screenshots/";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_DRM_NO_ATOMIC = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";

      GTK_IM_MODULE = "fcitx";
      #QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULES = "wayland;fcitx;ibus";
    };
  };
}
