# System-related modules
{...}: {
  imports = [
    #./boot
    ./doas
    ./docker
    ./documentation
    ./locale
    ./nix
    ./packages
    ./podman
    ./polkit
    ./users
    ./zram
  ];
}
