{
  pkgs,
  lib,
  ...
}: let
  # For running `steamtinkerlaunch addnonsteamgame` in cli without desktop manager
  # https://github.com/v1cont/yad/issues/277
  # https://github.com/NixOS/nixpkgs/blob/64e75cd44acf21c7933d61d7721e812eac1b5a0a/pkgs/by-name/st/steamtinkerlaunch/package.nix#L91C66-L91C106
  steamtinkerlaunch = pkgs.steamtinkerlaunch.overrideAttrs {
    patches = [./onsteamdeck-envvar.patch];
  };
in {
  home.packages = builtins.attrValues {
    inherit steamtinkerlaunch;
    inherit
      (pkgs)
      heroic
      mangohud
      prismlauncher
      protonup-qt
      steam
      #steamtinkerlaunch
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
    #inherit (flake.inputs.self.packages.${pkgs.system}) undertaker141;
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
