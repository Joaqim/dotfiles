{pkgs, ...}: {
  virtualization = {
    docker = {
      enable = true;
      extraPackages = [pkgs.docker-compose];
    };
  };
}
