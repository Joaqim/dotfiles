# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  mpv-skipsilence = {
    pname = "mpv-skipsilence";
    version = "5ae7c3b6f927e728c22fc13007265682d1ecf98c";
    src = fetchFromGitHub {
      owner = "ferreum";
      repo = "mpv-skipsilence";
      rev = "5ae7c3b6f927e728c22fc13007265682d1ecf98c";
      fetchSubmodules = false;
      sha256 = "sha256-fg8vfeb68nr0bTBIvr0FnRnoB48/kV957pn22tWcz1g=";
    };
    date = "2024-05-06";
  };
  yt-dlp = {
    pname = "yt-dlp";
    version = "164368610456e2d96b279f8b120dea08f7b1d74f";
    src = fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "164368610456e2d96b279f8b120dea08f7b1d74f";
      fetchSubmodules = false;
      sha256 = "sha256-FtP+WU6x2mojSYLm6tolSOoebOOmiOqXv9LzVW/Kces=";
    };
    date = "2025-01-16";
  };
}
