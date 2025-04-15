# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  GodotJS = {
    pname = "GodotJS";
    version = "v1.0.0";
    src = fetchFromGitHub {
      owner = "godotjs";
      repo = "GodotJS";
      rev = "v1.0.0";
      fetchSubmodules = false;
      sha256 = "sha256-kH6qzix0GMOU++EalTD6BGkuAsQRNYUv2OivnpWBgmw=";
    };
  };
  chronotube = {
    pname = "chronotube";
    version = "1.3.0";
    src = fetchurl {
      url = "https://github.com/necauqua/chronotube/releases/download/v1.3.0/chronotube-1.3.0-fx.xpi";
      sha256 = "sha256-H90V5IZ+ZjLddwiWzMvk5pTY6oL4kCCMZGQXGqRdR/4=";
    };
  };
  godot = {
    pname = "godot";
    version = "4.3-stable";
    src = fetchFromGitHub {
      owner = "godotengine";
      repo = "godot";
      rev = "4.3-stable";
      fetchSubmodules = false;
      sha256 = "sha256-v2lBD3GEL8CoIwBl3UoLam0dJxkLGX0oneH6DiWkEsM=";
    };
  };
  minecraft-modpack = {
    pname = "minecraft-modpack";
    version = "v2025.04.15";
    src = fetchurl {
      url = "https://github.com/Joaqim/MinecraftModpack/releases/download/v2025.04.15/Minecraft-Modpack-v2025.04.15.mrpack";
      sha256 = "sha256-MIMFiSDw5QkFi2WJxDM5JpcOP7xcrvKJq5IM+LdlskA=";
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
  twitchindicator = {
    pname = "twitchindicator";
    version = "3b685af607a7c67a3920cc9c9709a1056ba5c039";
    src = fetchFromGitHub {
      owner = "kuunha";
      repo = "twitchindicator";
      rev = "3b685af607a7c67a3920cc9c9709a1056ba5c039";
      fetchSubmodules = false;
      sha256 = "sha256-TuIuZ2AP14bA7ggj8543Cs1HM1Kk01ACTwjKdYv9dZA=";
    };
    date = "2025-02-19";
  };
  undertaker141 = {
    pname = "undertaker141";
    version = "v2.10.0";
    src = fetchurl {
      url = "https://github.com/AbdelrhmanNile/UnderTaker141/releases/download/latest/UnderTaker141.AppImage";
      sha256 = "sha256-LBt0or2sH/wyluPbRlhYVP/TqUlJYK34MKfFo8Y8pZU=";
    };
  };
  v8zip = {
    pname = "v8zip";
    version = "v8_12.4.254.21_r13";
    src = fetchurl {
      url = "https://github.com/ialex32x/GodotJS-Dependencies/releases/download/v8_12.4.254.21_r13/v8_12.4.254.21_r13.zip";
      sha256 = "sha256-v+0iW9kveu3tD/QFEX+wKhZ3vbmSTVVCErY1LYfW904=";
    };
  };
  yt-dlp = {
    pname = "yt-dlp";
    version = "2025.03.31";
    src = fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2025.03.31";
      fetchSubmodules = false;
      sha256 = "sha256-csw91VbzY9IursMQFGwnlobZI3U6QOBDo31oq+X0ETI=";
    };
  };
}
