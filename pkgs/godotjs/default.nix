{
  pkgs,
  stdenvNoCC,
  sources,
  ...
}: let
  godot_src = sources.godot.src;
  GodotJS_src = sources.GodotJS.src;
  v8zip = sources.v8zip.src;
  # Godot 4.3-stable
  commitHash = "77dcf97d82cbfe4e4615475fa52ca03da645dbd8";

  godot_src_with_godotjs = stdenvNoCC.mkDerivation {
    name = "GodotSrcWithGodotJS";
    dontBuild = true;
    srcs = [
      godot_src
      GodotJS_src
      v8zip
    ];
    buildInputs = [pkgs.unzip];
    unpackPhase = ''
      mkdir -p ./modules/GodotJS
      chmod 755 ./modules/GodotJS
      cp -r ${GodotJS_src}/* ./modules/GodotJS/
      unzip ${v8zip} -d ./modules/GodotJS
      cp -r ${godot_src}/* .

      mkdir .git
      echo "${commitHash}" > .git/HEAD
    '';
    installPhase = ''
      mkdir -p "$out"
      cp -r . "$out"
    '';
  };
in
  pkgs.godot_4_3.overrideAttrs
  (old: {
    inherit (sources.godot) version;
    pname = "godot4-js";
    src = godot_src_with_godotjs;
    nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.mold];
    meta.description = "Free and Open Source 2D and 3D game engine - bundled with GodotJS";
  })
