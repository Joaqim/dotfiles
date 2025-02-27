{pkgs, ...}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "twitchindicator";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "kuunha";
    repo = "twitchindicator";
  };

  installPhase = ''
    mkdir -p $out/usr/share/plasma/plasmoids/
    cp -r $src $out/org.github.kuunha.twitchindicator
  '';
}
