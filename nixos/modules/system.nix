{pkgs, ...}: {
  # This lets Caddy bind to ports: <1024
  security.wrappers."caddy" = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_bind_service=+ep";
    source = "${pkgs.caddy}/bin/caddy";
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
