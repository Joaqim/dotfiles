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
    version = "6ca23ffaa4663cb552f937f0b1e9769b66db11bd";
    src = fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "6ca23ffaa4663cb552f937f0b1e9769b66db11bd";
      fetchSubmodules = false;
      sha256 = "sha256-NzyfQrtMNWIf/A/KnhEFhJeoPWTx38/CMzuf4ALpB8U=";
    };
    date = "2025-02-11";
  };
}
