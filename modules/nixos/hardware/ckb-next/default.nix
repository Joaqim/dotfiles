# CKB Next keyboard/mouse driver
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.ckb-next;
in
{
  options.my.hardware.ckb-next = with lib; {
    enable = mkEnableOption "CKB Next keyboard/mouse drivers and user configuration";

    enableAutoStart = my.mkDisableOption "enable autostart";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/NixOS/nixpkgs/issues/444209#issuecomment-3315031496
    hardware.ckb-next = {
      enable = true;
      package = pkgs.ckb-next.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DUSE_DBUS_MENU=0" ];
      });
    };
    environment.systemPackages = [
      (pkgs.makeAutostartItem rec {
        name = "ckb-next";
        package = pkgs.makeDesktopItem {
          inherit name;
          desktopName = "CKB Next";
          exec = "ckb-next --background";
          icon = "ckb-next";
          extraConfig = {
            OnlyShowIn = "KDE";
          };
        };
      })
    ];
  };
}
