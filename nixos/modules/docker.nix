{pkgs, ...}: {
  virtualisation = {
    docker = {
      enable = true;
      extraPackages = [pkgs.docker-compose];
    };
  };
}
