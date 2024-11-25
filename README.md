
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

## Thinkpad

Configure [./systems/thinkpad/disko-config.nix](./systems/thinkpad/disko-config.nix) for appropriate memory device /dev/sd*

```shell
sudo nix run github:nix-community/disko -- --mode disko ./systems/thinkpad/disko-config.nix
```

Get UUID for `boot` `root` and `swap`:
```shell
lsblk -a -f
```
Edit [./systems/thinkpad/hardware-config.nix](./systems/thinkpad/hardware-config.nix) to fit the new partitions.

Make sure `/dev/sd*1` and `/dev/sd*2` is mounted at `/mnt/boot` and `/mnt`, respectively.

Install `thinkpad` system configuration to mounted partitions:
```shell
sudo nixos-install --root /mnt --flake ./#thinkpad
```
## Resources

[TLATER/dotfiles - Sops secrets](https://github.com/TLATER/dotfiles/tree/e2432f2928ed2462852416dd54068f8c0c45dc6d#dotfiles)


[TLATER/dotfiles](https://github.com/TLATER/dotfiles)

[Misterio77/nix-config](https://github.com/Misterio77/nix-config)

[BRBWaffles/dotfiles](https://gitlab.com/BRBWaffles/dotfiles)

[Faupi/nixos-configs](https://github.com/Faupi/nixos-configs/tree/master)
