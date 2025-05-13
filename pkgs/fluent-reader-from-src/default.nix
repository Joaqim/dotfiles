{
  lib,
  sources,
  buildNpmPackage,
  electron,
  makeBinaryWrapper,
  nix-update-script,
  ...
}: let
  inherit (sources.fluent-reader) src version;
in
  buildNpmPackage {
    inherit src;
    pname = "fluent-reader-from-src";
    version = lib.strings.removePrefix "v" version;

    npmDepsHash = "sha256-okonmZMhsftTtmg4vAK1n48IiG+cUG9AM5GI6wF0SnM=";

    nativeBuildInputs = [
      makeBinaryWrapper
    ];

    ELECTRON_SKIP_BINARY_DOWNLOAD = true;

    makeCacheWritable = true;

    buildPhase = ''
      runHook preBuild

      npm run build

      npm exec electron-builder -- \
          --linux \
          --x64 \
          --dir \
          -p never \
          -c.electronDist=${electron.dist} \
          -c.electronVersion=${electron.version}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fluent-reader

      cp -r ./bin/linux/x64/linux-unpacked $out/dist
      cp -a ./bin/linux/x64/linux-unpacked/{locales,resources} $out/share/fluent-reader

      runHook postInstall
    '';

    postFixup = ''
      makeWrapper $out/dist/fluent-reader $out/bin/fluent-reader \
        --add-flags "--no-sandbox --disable-gpu-sandbox"
    '';

    passthru.updateScript = nix-update-script {};

    meta = with lib; {
      description = "Modern desktop RSS reader built with Electron, React, and Fluent UI";
      mainProgram = "fluent-reader";
      homepage = "https://hyliu.me/fluent-reader";
      license = licenses.bsd3;
      platforms = ["x86_64-linux"];
    };
  }
