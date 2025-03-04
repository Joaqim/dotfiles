{lib, ...}: {
  # Many of these are enabled by default, use modules/nixos/profiles to selectively disable per `user` and/or `system`
  imports = [
    #./aliases
    ./atuin
    ./bat
    ./bluetooth
    ./boilr
    ./bottom
    ./calibre
    ./dircolors
    ./direnv
    ./discord
    ./documentation
    #./feh
    ./firefox
    ./flameshot
    ./fzf
    ./gaming
    #./gammastep
    #./gdb
    ./git
    ./gpg
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
    ./xdg
    ./zathura
    #./zsh
  ];

  home.stateVersion = lib.mkForce "24.11";
}
