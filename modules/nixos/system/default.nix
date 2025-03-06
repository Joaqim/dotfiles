# System-related modules
{...}: {
  imports = [
    #./boot
    ./doas
    ./docker
    ./documentation
    ./impermanence
    ./locale
    ./nix
    ./packages
    ./podman
    ./polkit
    ./users
    ./zram
  ];
}
