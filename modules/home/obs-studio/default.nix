{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.obs-studio;
in
{
  options.my.home.obs-studio = with lib; {
    enable = mkEnableOption "obs-studio configuration";
  };
  # TODO: dynamic Nvidia/AMD support https://wiki.nixos.org/w/index.php?title=OBS_Studio
  # For now, only assumes AMD
  config.programs.obs-studio = lib.mkIf cfg.enable {
    enable = true;
    package = pkgs.obs-studio.override {
      cudaSupport = false; # TODO:
    };
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi # optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
