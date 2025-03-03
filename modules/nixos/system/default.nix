# System-related modules
{...}: {
  imports = [
    #./boot
    ./docker
    ./documentation
    ./locale
    ./nix
    ./packages
    ./podman
    ./polkit
    ./users
  ];
}
