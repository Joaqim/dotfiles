{
  stdenvNoCC,
  sources,
  pkgs,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (sources.twitchindicator) pname version src;
  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = with pkgs; [
    kdePackages.wrapQtAppsHook
  ];

  runtimeDependencies = with pkgs.libsForQt5.qt5; [
    qtgraphicaleffects
    qtwebengine
  ];

  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/
    cp -r $src/package $out/share/plasma/plasmoids/org.github.komorebi.twitchindicator
  '';
}
