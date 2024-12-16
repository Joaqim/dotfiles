{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
  ];
  /*
  home.file."./justfile".content = lib.mkForce  ''
      rcon:
        sudo docker exec -it minecraft-vault-hunters rcon-cli
      stop:
        sudo docker stop docker-minecraft-vault-hunters
      start:
        sudo docker start docker-minecraft-vault-hunters
      restart:
        sudo docker restart docker-minecraft-vault-hunters
      journal:
        sudo journalctl -u docker-minecraft-vault-hunters
      journal -f:
        sudo journalctl -fu docker-minecraft-vault-hunters
    '';
  */
}
