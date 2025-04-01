{
  makeDesktopItem,
  stdenvNoCC,
  writeScriptBin,
  kdePackages,
  shellcheck,
  makeWrapper,
  lib,
  ...
}: let
  # https://ertt.ca/nix/shell-scripts/
  # https://github.com/schlichtanders/nixos-personal/blob/7ec6fe5e9151b3d0cc5be7861842311b5e9ec7cc/overlays/overlay-tiddlydesktop.nix
  name = "mpv-history-launcher";
  script = (writeScriptBin name (builtins.readFile ./mpv-history-launcher.sh)).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  dependencies = [kdePackages.kdialog];
in
  stdenvNoCC.mkDerivation rec {
    inherit name;
    pname = name;
    phases = ["installPhase"];
    nativeBuildInputs = [shellcheck makeWrapper];

    desktopItem = makeDesktopItem {
      name = "mpv History Launcher";
      desktopName = "mpv History Launcher";
      exec = "${pname}";
      icon = "mpv";
      genericName = "Simple KDialog to select from recent mpv history.";
      categories = ["KDE" "Utility"];
    };

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${script}/bin/${pname} $out/bin/

      wrapProgram $out/bin/${pname} --prefix PATH : ${
        lib.makeBinPath
        dependencies
      }

      # Create Desktop Item
      mkdir -p "$out/share/applications"
      ln -s "${desktopItem}"/share/applications/* "$out/share/applications/"
    '';

    meta = {
      mainProgram = "${pname}";
      description = "Simple KDialog to select from recent mpv history.";
    };
  }
