{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
      loop-file = "inf";
    };
  };
}
