{flake, ...}: let
  inherit
    (flake.config.people)
    user0
    ;
in {
  services = {
    syncthing = {
      enable = true;
      user = "${user0}";
      group = "users";
      dataDir = "/home/${user0}/Syncthing";
      guiAddress = "0.0.0.0:8384";
      settings = {
        folders = {
          "/home/${user0}/Documents" = {
            id = "${user0}-home-Documents";
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
