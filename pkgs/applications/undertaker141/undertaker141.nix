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

  gameDependencies = builtins.attrValues {
    inherit
      (pkgs)
      mangohud
      # jc141 & wine
      dwarfs
      winetricks
      psmisc # for `fuser`
      fuse-overlayfs
      vulkan-loader
      vulkan-tools
      bubblewrap
      # optional deps
      libva
      openal
      libpulseaudio
      giflib
      libgphoto2
      libxcrypt
      alsa-utils
      SDL2_ttf
      SDL2_image
      libthai
      harfbuzz
      fontconfig
      freetype
      libz
      libdrm
      fribidi
      libgpg-error
      libGL
      libGLU
      ;
    inherit
      (pkgs.xorg)
      libXext
      libXrender
      libXfixes
      libXrandr
      libXcursor
      libXcomposite
      ;
    inherit
      (pkgs.gst_all_1)
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gst-vaapi
      gst-libav
      ;
    inherit
      (pkgs.wineWowPackages)
      waylandFull
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

    buildInputs = gameDependencies;
    runtimeDependencies = gameDependencies;

    # TODO: https://github.com/fufexan/nix-gaming/blob/master/pkgs/rocket-league/default.nix
    installPhase = ''
      mkdir "$out"
      cp -ar . "$out/app"
      cd "$out"

      # Remove the AppImage runner, actual entry point will be the `undertaker141` script
      rm app/AppRun

      # Remove redundant symlink to app/usr/share/applications/python3.11.4.desktop
      rm app/python3.11.4.desktop

      # Adjust directory structure, so that the `.desktop` etc. files are
      # properly detected
      mv app/usr/share .
      mv app/usr/lib .
      mv app/usr/bin .
      mv app/opt .

      mv bin/python3.11 "$out/app/${pname}"

      # Adjust the `.desktop` file
      substitute share/applications/python3.11.4.desktop \
        share/applications/undertaker141.desktop \
        --replace-fail 'Exec=python3.11' 'Exec=${pname}' \
        --replace-fail 'Icon=python' 'Icon=undertaker141'

      # Ensure the icon is copied to the right place
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp ${icon}/share/icons/hicolor/512x512/apps/undertaker141.png $out/share/icons/hicolor/512x512/apps/

      # Build the main executable
      cat > bin/${pname} <<EOF
      #! $SHELL -e

      export WINEARCH="win64"
      export APPDIR="$out"

      # jc141 specific options
      export DBG=1
      export ISOLATE=0
      export BLOCK_NET=0
      SYSWINE="$(command -v wine)"

      # Export TCl/Tk
      export TCL_LIBRARY="$out/usr/share/tcltk/tcl8.6"
      export TK_LIBRARY="$out/usr/share/tcltk/tk8.6"
      export TKPATH="$out"

      # Export SSL certificate
      export SSL_CERT_FILE="$out/opt/_internal/certs.pem"

      export PYTHONHOME="$out/opt/python3.11"

      # Call Python
      "$out/opt/python3.11/bin/python3.11" "$out/opt/src/app.py"
      EOF

      chmod +x bin/${pname}

      wrapProgram $out/bin/${pname} --prefix PATH : ${
        lib.makeBinPath
        gameDependencies
      }
    '';

    meta = with lib; {
      homepage = "https://github.com/AbdelrhmanNile/UnderTaker141";
    };
  }
