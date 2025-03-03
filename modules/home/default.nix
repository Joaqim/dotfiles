{
  lib,
  pkgs,
  ...
}: {
  # Many of these are enabled by default, use modules/nixos/profiles to selectively disable per `user` and/or `system`
  imports = [
    #./aliases
    ./atuin
    ./bat
    ./bluetooth
    ./bottom
    ./calibre
    ./dircolors
    ./direnv
    ./discord
    ./documentation
    #./feh
    #./firefox
    ./flameshot
    ./fzf
    #./gammastep
    #./gdb
    #./git
    #./gpg
    #./gtk
    ./htop
    ./jq
    ./mpv
    ./nix
    ./nix-index
    ./nixpkgs
    ./nm-applet
    ./packages
    ./pager
    ./power-alert
    #./secrets
    #./ssh
    #./terminal
    #./tmux
    ./udiskie
    #./vim
    #./wget
    #./wm
    #./x
    #./xdg
    ./zathura
    #./zsh
  ];

  home.packages = with pkgs; [
    jqp.undertaker141
    jqp.mpv-history-launcher

    calibre
    nh
  ];

  home.stateVersion = lib.mkForce "24.11";
}
