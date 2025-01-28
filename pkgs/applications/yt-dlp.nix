{
  pkgs,
  sources,
  python3Packages,
  ffmpeg-headless,
  rtmpdump,
  atomicparsley,
  atomicparsleySupport ? true,
  ffmpegSupport ? true,
  rtmpSupport ? true,
  withAlias ? false, # Provides bin/youtube-dl for backcompat
  ...
}: let
  inherit (pkgs) lib update-python-libraries;
in
  # Taken from: https://github.com/NixOS/nixpkgs/blob/eb62e6aa39ea67e0b8018ba8ea077efe65807dc8/pkgs/by-name/yt/yt-dlp/package.nix#L97
  # TODO: This is probably the naive way to override a `nixpkgs` package - will replace in the future.
  python3Packages.buildPythonApplication rec {
    inherit (sources.yt-dlp) pname version src;
    pyproject = true;

    build-system = with python3Packages; [
      hatchling
    ];

    # expose optional-dependencies, but provide all features
    dependencies = lib.flatten (lib.attrValues optional-dependencies);

    optional-dependencies = {
      default = with python3Packages; [
        brotli
        certifi
        mutagen
        pycryptodomex
        requests
        urllib3
        websockets
      ];
      curl-cffi = [python3Packages.curl-cffi];
      secretstorage = with python3Packages; [
        cffi
        secretstorage
      ];
    };

    pythonRelaxDeps = ["websockets"];

    # Ensure these utilities are available in $PATH:
    # - ffmpeg: post-processing & transcoding support
    # - rtmpdump: download files over RTMP
    # - atomicparsley: embedding thumbnails
    makeWrapperArgs = let
      packagesToBinPath =
        lib.optional atomicparsleySupport atomicparsley
        ++ lib.optional ffmpegSupport ffmpeg-headless
        ++ lib.optional rtmpSupport rtmpdump;
    in
      lib.optionals (packagesToBinPath != []) [
        ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"''
      ];

    setupPyBuildFlags = [
      "build_lazy_extractors"
    ];

    # Requires network
    doCheck = false;

    # curl-cffi 0.7.2 and 0.7.3 are broken, but 0.7.4 is fixed
    # https://github.com/lexiforest/curl_cffi/issues/394
    postPatch = ''
      substituteInPlace yt_dlp/networking/_curlcffi.py \
        --replace-fail "(0, 7, 0) <= curl_cffi_version < (0, 7, 2)" \
          "((0, 7, 0) <= curl_cffi_version < (0, 7, 2)) or curl_cffi_version >= (0, 7, 4)"
    '';

    postInstall = lib.optionalString withAlias ''
      ln -s "$out/bin/yt-dlp" "$out/bin/youtube-dl"
    '';

    passthru.updateScript = [
      update-python-libraries
      (toString ./.)
    ];

    meta = with lib; {
      homepage = "https://github.com/yt-dlp/yt-dlp/";
      description = "Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)";
      longDescription = ''
        yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.

        youtube-dl is a small, Python-based command-line program
        to download videos from YouTube.com and a few more sites.
        youtube-dl is released to the public domain, which means
        you can modify it, redistribute it or use it however you like.
      '';
      changelog = "https://github.com/yt-dlp/yt-dlp/blob/HEAD/Changelog.md";
      license = licenses.unlicense;
      maintainers = with maintainers; [
        SuperSandro2000
        donteatoreo
      ];
      mainProgram = "yt-dlp";
    };
  }
