{
  pkgs,
  sources,
}:
pkgs.yt-dlp.overrideAttrs {
  inherit (sources.yt-dlp) src;
  pname = "yt-dlp-git";
  version = "${sources.yt-dlp.date}";
}
