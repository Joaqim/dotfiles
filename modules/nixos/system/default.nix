# System-related modules
{ ... }:
{
  imports = [
    #./boot
    ./doas
    ./docker
    ./documentation
    ./impermanence
    ./language
    ./nix
    ./packages
    ./podman
    ./polkit
    ./users
    ./zram
  ];
}
