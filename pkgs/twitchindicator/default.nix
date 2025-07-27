{
  sources,
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  kdePackages,
  ...
}:
stdenv.mkDerivation {
  inherit (sources.twitchindicator) pname version src;
  # Adds CMakeLists.txt not provided by upstream
  patches = [ ./cmake.patch ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kdePackages.plasma-desktop
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_PLASMOID" true)
    (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Displays a list of live channels you're following on Twitch";
    longDescription = ''
      Displays a list of live channels you're following on Twitch - Plasma6 port of original widget by github:komorebinator
    '';
    homepage = "https://github.com/kuunha/twitchindicator";
    license = licenses.wtfpl;
    platforms = platforms.linux;
  };
}
