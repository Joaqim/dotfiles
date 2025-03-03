{
  pkgs,
  lib,
  ...
}: {
  home = {
    file."./.local/share/Steam/steam_dev.cfg".source = ../../../nixos/modules/steam/steam_dev.cfg;
    packages = builtins.attrValues {
      inherit
        (pkgs)
        heroic
        mangohud
        prismlauncher
        protonup-qt
        steam
        steamtinkerlaunch
        # jc141 stuff
        dwarfs
        winetricks
        psmisc # for `fuser`
        fuse-overlayfs
        vulkan-loader
        vulkan-tools
        bubblewrap
        ;
      nexusmods-app = pkgs.nexusmods-app.override {
        _7zz = pkgs._7zz-rar;
      };
    };
  };
  # Run Boilr on startup to create Icons and Banners in Steam
  systemd.user.services.boilr = {
    Unit = {
      Description = "Run Boilr to automatically add artwork to non-Steam shortcuts.";
      After = ["NetworkManager.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.boilr} --no-ui";
      Restart = "on-failure";
      Type = "oneshot";
    };
    Install = {
      WantedBy = ["multi-user.target"];
    };
  };
}
