
## Steam Deck

Using [disko-install](https://github.com/nix-community/disko/blob/master/docs/disko-install.md):

Experimentally, install to USB-stick (/dev/sda):

```shell
sudo nix run 'github:nix-community/disko#disko-install' -- --flake ./#deck --disk main /dev/sda
```
Afterwards, we can test the result:
```shell
sudo qemu-kvm -enable-kvm -hda /dev/sda
```

## Resources

[TLATER/dotfiles - Sops secrets](https://github.com/TLATER/dotfiles/tree/e2432f2928ed2462852416dd54068f8c0c45dc6d#dotfiles)


[TLATER/nixos-config](https://github.com/TLATER/nixos-config)

[Misterio77/nix-config](https://github.com/Misterio77/nix-config)

[BRBWaffles/dotfiles](https://gitlab.com/BRBWaffles/dotfiles)