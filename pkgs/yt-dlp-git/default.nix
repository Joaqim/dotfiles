{
  pkgs,
  sources,
}:
pkgs.yt-dlp.overrideAttrs {
  pname = "yt-dlp-git";
  inherit (sources.yt-dlp) version src;
}
