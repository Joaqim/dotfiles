{
  stdenvNoCC,
  sources,
  lib,
}:
let
  addonId = "{b97280fa-db1f-454e-83a9-e399f241c7f1}";
  meta = with lib; {
    homepage = "https://github.com/necauqua/chronotube#readme";
    description = "Automatically updates current YouTube or Twitch VOD URL with the timecode of the playing video";
    license = licenses.mit;
    platforms = platforms.all;
  };
  ver = "v${sources.chronotube.version}";
in
# https://discourse.nixos.org/t/add-custom-addons-to-firefox-directly-from-https-addons-mozilla-org/48730/3
# https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/default.nix#L5
stdenvNoCC.mkDerivation rec {
  inherit (sources.chronotube) pname src;
  inherit meta;

  name = "${pname}-${ver}";
  version = "${ver}";

  preferLocalBuild = true;
  allowSubstitutes = true;

  passthru = { inherit addonId; };

  buildCommand = ''
    dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    mkdir -p "$dst"
    install -v -m644 "$src" "$dst/${addonId}.xpi"
  '';
}
