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
    version = "03c3d705778c07739e0034b51490877cffdc0983";
    src = fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "03c3d705778c07739e0034b51490877cffdc0983";
      fetchSubmodules = false;
      sha256 = "sha256-RxlfmNxGEq6AulLJUnGhFwBzuvPxcS8o3pO/Km1iVvM=";
    };
    date = "2025-01-30";
  };
}
