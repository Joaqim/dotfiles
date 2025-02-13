# UnderTaker141 appimage module, based on:
# https://github.com/thomX75/nixos-modules/blob/main/XnViewMP/xnviewmp.nix
{
  pkgs,
  lib,
  ...
}: let
  # Set Version and SHA
  undertaker141Version = "2.7.0";
  undertaker141SHA = "1gb3a9nw3svbg3ypf557h5ygvfapw3nznchvr91yjrg3wwl6v3n4";

  inherit (pkgs) appimageTools autoPatchelfHook stdenvNoCC makeWrapper runCommand;

  pname = "undertaker141";
  version = "${undertaker141Version}";

  dependencies = builtins.attrValues {
    inherit
      (pkgs)
      freetype
      libgcc
      libz
      libGL
      python311
      ;
    inherit
      (pkgs.xorg)
      libX11
      libXrender
      ;
    inherit
      (pkgs.stdenv.cc.cc)
      lib
      ;
  };

  # Fetch and convert the icon
  icon =
    runCommand "undertaker141-icon" {
      nativeBuildInputs = [pkgs.imagemagick];
      src = pkgs.fetchurl {
        url = "https://github.com/AbdelrhmanNile/UnderTaker141/blob/main/undertaker.png?raw=true";
        sha256 = "sha256-yumhWiKWPPhlMgVS3SEYTP8JRup/6UKrJiu8MRrug04=";
      };
    } ''
      mkdir -p $out/share/icons/hicolor/512x512/apps
      magick $src -resize 512x512 $out/share/icons/hicolor/512x512/apps/undertaker141.png
    '';

  src = pkgs.fetchurl {
    url = "https://github.com/Joaqim/UnderTaker141/releases/download/latest/UnderTaker141.AppImage";
    sha256 = "${undertaker141SHA}";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = appimageContents;

    dontConfigure = true;
    dontBuild = true;
    multiPkgs = null;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = dependencies;
    runtimeDependencies = dependencies;

    installPhase = ''
      cp -ar . "$out/"
      cd "$out"

      # Remove the AppImage runner, actual entry point will be the `undertaker141` script
      rm AppRun*

      # Remove redundant symlink to usr/share/applications/python3.11.4.desktop
      rm python3.11.4.desktop

      mkdir -p $out/share/applications

      # Adjust the `.desktop` file
      substitute usr/share/applications/python3.11.4.desktop \
        $out/share/applications/undertaker141.desktop \
        --replace-fail 'Exec=python3.11' 'Exec=${pname}' \
        --replace-fail 'Icon=python' 'Icon=undertaker141'

      rm usr/share/applications/python3.11.4.desktop

      # Ensure the icon is copied to the right place
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp ${icon}/share/icons/hicolor/512x512/apps/undertaker141.png $out/share/icons/hicolor/512x512/apps/

      mkdir $out/bin
      # Build the main executable
      cat > bin/${pname} <<EOF
      #! $SHELL -e

      export APPDIR="$out"

      # Export TCl/Tk
      export TCL_LIBRARY="$out/usr/share/tcltk/tcl8.6"
      export TK_LIBRARY="$out/usr/share/tcltk/tk8.6"
      export TKPATH="$out"

      # Export SSL certificate
      export SSL_CERT_FILE="$out/opt/_internal/certs.pem"

      export PYTHONHOME="$out/opt/python3.11"

      # Call Python
      #"$out/opt/python3.11/bin/python3.11" "$out/opt/src/app.py"
      python3.11 "$out/opt/src/app.py"
      EOF

      chmod +x bin/${pname}

      wrapProgram $out/bin/${pname} --prefix PATH : ${
        lib.makeBinPath
        dependencies
      }
    '';

    meta = with lib; {
      homepage = "https://github.com/AbdelrhmanNile/UnderTaker141";
    };
  }
