{ config, lib, ... }:
let
  cfg = config.my.services.zt-services-trust;
  # Ensure this path points to where you've stored the cert in your flake/repo
  caddyCert = ./pki/caddy-root-ca.crt;
in
{
  options.my.services.zt-services-trust.enable =
    lib.mkEnableOption "Caddy internal CA trust for .zt services";

  config = lib.mkIf cfg.enable {
    # On NixOS, this is the 'Source of Truth' for all system-wide
    # trusted certificates (Curl, Python, Chrome, System services).
    security.pki.certificateFiles = [ caddyCert ];
  };
}
