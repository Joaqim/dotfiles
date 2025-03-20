# Taken from [1]:
# [1]: https://github.com/ambroisie/nix-config/blob/main/lib/options.nix
{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  # Create an option which is enabled by default, in contrast to
  # `mkEnableOption` ones which are disabled by default.
  mkDisableOption = description: (mkEnableOption description) // {default = true;};
}
