{
  pkgs,
  sources,
}:
pkgs.yt-dlp.overrideAttrs {
  inherit (sources.yt-dlp) version src date;
}
