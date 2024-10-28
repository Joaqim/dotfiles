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
    version = "v5.28.1";
    src = fetchFromGitHub {
      owner = "richardwilkes";
      repo = "gcs";
      rev = "v5.28.1";
      fetchSubmodules = false;
      sha256 = "sha256-R243j0KUIE8ii7jWB96aD7BtQsIM4VVJqcwbL4fBMKE=";
    };
  };
}
