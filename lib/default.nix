# Extension taken from [2], which refers to [1].
# [1]: https://github.com/hlissner/dotfiles/blob/master/lib/default.nix
# [2]: https://github.com/ambroisie/nix-config/blob/main/lib/default.nix
{
  lib,
  pkgs,
  inputs,
}: let
  inherit (lib) makeExtensible attrValues foldr;
  inherit (modules) mapModules;

  modules = import ./modules.nix {
    inherit lib;
    self.attrs = import ./attrs.nix {
      inherit lib;
      self = {};
    };
  };

  mylib = makeExtensible (
    self:
      mapModules ./. (file: import file {inherit self lib pkgs inputs;})
  );
in
  mylib.extend (_self: super: foldr (a: b: a // b) {} (attrValues super))
