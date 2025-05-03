{
  flake-inputs,
  sources,
}: let
  inherit (flake-inputs.erosanix.lib.x86_64-linux) mkWindowsAppNoCC;
  inherit (sources) nbt-studio;
  # For some reason, I couldn't get any mkWindowApp packages to work with `nixos-unstable`
  pkgs = import flake-inputs.nixpkgs-master {system = "x86_64-linux";};
  inherit (pkgs) wineWowPackages;
in
  mkWindowsAppNoCC rec {
    inherit (nbt-studio) pname src version;
    preferLocalBuild = true;
    allowSubstitutes = true;
    dontUnpack = true;

    wine = wineWowPackages.base;
    wineArch = "win64";
    # Reduce number of re builds
    # But it reduces reproducibility
    inputHashMethod = "version";

    # Since this is a portable executable we only only install dotnet runtime dependencies
    # and copy the executable to the wineprefix
    winAppInstall = ''
      winetricks -q dotnetdesktop6
      dest="$WINEPREFIX/drive_c/${pname}"
      mkdir -p "$dest"
      cp "${src}" "$dest/NbtStudio.exe"
    '';

    winAppRun = ''
      wine start /unix "$WINEPREFIX/drive_c/${pname}/NbtStudio.exe" "$ARGS"
    '';

    installPhase = ''
      runHook preInstall

      ln -s $out/bin/.launcher $out/bin/${pname}

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/tryashtar/nbt-studio#README.md";
      platforms = ["x86_64-linux"];
      #license = "";
      # (c) Copyright 2025 github.com/tryashtar, all rights reserved.
      # See: https://github.com/tryashtar/nbt-studio/issues/25#issuecomment-883725189
    };
  }
