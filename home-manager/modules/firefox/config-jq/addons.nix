{
  buildFirefoxXpiAddon,
  lib,
}: {
  # https://discourse.nixos.org/t/add-custom-addons-to-firefox-directly-from-https-addons-mozilla-org/48730/3
  chronotube = buildFirefoxXpiAddon rec {
    pname = "chronotube";
    version = "1.3.0";
    addonId = "{b97280fa-db1f-454e-83a9-e399f241c7f1}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3606813/${pname}-${version}.xpi";
    sha256 = "sha256-H90V5IZ+ZjLddwiWzMvk5pTY6oL4kCCMZGQXGqRdR/4=";
    meta = with lib; {
      homepage = "https://github.com/necauqua/chronotube#readme";
      description = "Automatically updates current YouTube or Twitch VOD URL with the timecode of the playing video";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
}
