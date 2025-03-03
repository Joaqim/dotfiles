{
  stdenvNoCC,
  lib,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "mpv-org-history";
  version = "1.0.1";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = ./mpv-org-history.lua;
  };
  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    install -Dm644 ${src}/mpv-org-history.lua $out/share/mpv/scripts/mpv-org-history.lua
  '';
  passthru.scriptName = "mpv-org-history.lua";
  meta = {
    description = "Extensive org formatted log will be saved to `~/Documents/org/mpv-history.org`";
  };
}
