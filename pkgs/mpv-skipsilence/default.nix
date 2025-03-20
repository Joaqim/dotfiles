{
  stdenvNoCC,
  lib,
  sources,
  ...
}:
stdenvNoCC.mkDerivation rec {
  inherit (sources.mpv-skipsilence) pname version src;
  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    install -Dm644 ${src}/skipsilence.lua $out/share/mpv/scripts/skipsilence.lua
  '';
  passthru.scriptName = "skipsilence.lua";
  meta = {
    description = "Increase playback speed during silence.";
    longDescription = "Increase playback speed during silence - a revolution in attention-deficit induction technology.";
    homepage = "https://codeberg.org/ferreum/mpv-skipsilence#mpv-skipsilence";
    license = lib.licenses.gpl2;
  };
}
