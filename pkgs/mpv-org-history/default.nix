{stdenvNoCC, ...}:
stdenvNoCC.mkDerivation {
  pname = "mpv-org-history";
  version = "1.0.1";
  src = ./mpv-org-history.lua;
  dontBuild = true;
  dontUnpack = true;
  dontCheck = true;
  preferLocalBuild = true;
  installPhase = ''
    install -Dm644 $src $out/share/mpv/scripts/mpv-org-history.lua
  '';
  passthru.scriptName = "mpv-org-history.lua";
  meta = {
    description = "Extensive org formatted log will be saved to `~/Documents/org/mpv-history.org`";
  };
}
