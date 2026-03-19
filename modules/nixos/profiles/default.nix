# Configuration that spans across system and home, or are collections of modules
{ ... }:
{
  imports = [
    ./bluetooth
    ./devices
    ./fcitx5
    ./hyprland
    ./language
    #./laptop
    ./minecraft-server
    ./minecraft-server-lucky-world-invasion
    ./plasma
    ./steam-deck
    ./xkb
  ];
}
