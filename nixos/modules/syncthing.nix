{
  flake,
  lib,
  ...
}: let
  inherit
    (flake.config.people)
    user0
    ;
in {
  services = {
    syncthing = {
      enable = lib.mkDefault true;
      user = "${user0}";
      group = "users";
      dataDir = "/home/${user0}/Syncthing";
      guiAddress = "0.0.0.0:8384";
      # overrides any devices or folders added or deleted through the WebUI
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        folders = {
          "/home/${user0}/Documents" = {
            id = "${user0}-home-Documents";
            devices = ["desktop"];
          };
          "/home/${user0}/.local/share/PrismLauncher" = {
            id = "${user0}-PrismLauncher";
            devices = ["desktop"];
          };
        };
        devices = {
          "desktop" = {
            addresses = [
              "tcp://desktop:51820"
            ];
            id = "NLIZ57J-R7OP4Z6-FVTX2A3-QCCDSP3-2ZTYJSJ-T2QXMM3-EFHAKI4-NTWGJQT ";
          };
        };
      };
    };
  };
}
