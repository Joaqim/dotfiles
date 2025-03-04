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
    ./kde
    ./mpv
    ./nix
    ./nix-index
    ./nixpkgs
    ./nm-applet
    ./nushell
    ./packages
    ./pager
    ./power-alert
    ./qbittorrent
    #./secrets
    #./ssh
    ./starship
    ./terminal
    #./tmux
    ./udiskie
    #./vim
    ./vscode
    #./wget
    #./wm
    #./x
    ./xdg
    ./zathura
    #./zsh
  ];

  home.stateVersion = lib.mkForce "24.11";
}
