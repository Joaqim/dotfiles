{
  pkgs,
  lib,
  config,
  ...
}: let
  # For running `steamtinkerlaunch addnonsteamgame` in cli
  # https://github.com/v1cont/yad/issues/277
  # https://github.com/NixOS/nixpkgs/blob/64e75cd44acf21c7933d61d7721e812eac1b5a0a/pkgs/by-name/st/steamtinkerlaunch/package.nix#L91C66-L91C106
  steamtinkerlaunch = pkgs.steamtinkerlaunch.overrideAttrs ({postInstall, ...}: {
    postInstall =
      postInstall
      + ''
        substituteInPlace \
          $out/bin/steamtinkerlaunch \
            --replace \
              "ONSTEAMDECK=0" \
              "ONSTEAMDECK=''${ONSTEAMDECK:-0}"
      '';
  });
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
  # TODO: Move this to its own module, as a service
  sops.templates."boilr-config" = {
    content = ''
      ${builtins.readFile ./boilr-config.toml}
      auth_key = "${config.sops.placeholder."steamgrid_db_auth_key"}"
    '';
    # See: https://github.com/Mic92/sops-nix/issues/681
    path = "${config.xdg.configHome}/sops-nix/secrets/rendered/boilr-config.toml";
    mode = "600";
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
