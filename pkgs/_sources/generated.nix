# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  bauer = {
    pname = "bauer";
    version = "v2.0.1";
    src = fetchFromGitHub {
      owner = "matthewbauer";
      repo = "bauer";
      rev = "v2.0.1";
      fetchSubmodules = false;
      sha256 = "sha256-jenFLJeVX1OlckvCv+c/u2GG8UNQatfQ8OwPu1cs4Q8=";
    };
  };
  gauth = {
    pname = "gauth";
    version = "v1.3.0";
    src = fetchFromGitHub {
      owner = "pcarrier";
      repo = "gauth";
      rev = "v1.3.0";
      fetchSubmodules = false;
      sha256 = "sha256-GU6HKha7Y01HJX6pyYHORUkFKgl9mWtDd65d+3pYxjI=";
    };
  };
  gcs = {
    pname = "gcs";
    version = "v5.30.0";
    src = fetchFromGitHub {
      owner = "richardwilkes";
      repo = "gcs";
      rev = "v5.30.0";
      fetchSubmodules = false;
      sha256 = "sha256-W0D+5qU6XdZugySHTP6VvwCve9YwyQIvX1T16Dk86rE=";
    };
  };
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
}
