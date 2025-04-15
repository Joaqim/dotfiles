{
  stdenvNoCC,
  sources,
  ...
}:
stdenvNoCC.mkDerivation rec {
  inherit (sources.minecraft-modpack) pname version src;
  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    dst="$out/share/minecraft-modpacks"
    mkdir -p "$dst"
    install -Dm644 "${src}" "$dst/MinecraftModpack.mrpack"
  '';
  # TODO: Build modpack using source github flake
  # TODO: Get modpack Minecraft and Fabric/Forge version from pack.toml
  # TODO: Install icon.jpeg to "$dst/MinecraftModpack-icon.jpeg"
  passthru = {
    modpack = "MinecraftModpack.mrpack";
    modpackName = "Minecraft Modpack";
    modpackVersion = "${version}";
  };
  meta = {
    description = "Minecraft Modpack created using Packwiz and Nix ";
    longDescription = "Minecraft Modpack created using Packwiz and Nix - fork of https://github.com/pedorich-n/MinecraftModpack";
    homepage = "http://www.joaqim.com/MinecraftModpack";
  };
}
