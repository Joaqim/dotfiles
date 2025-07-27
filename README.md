# NixOS Config

[![Nix Status](https://github.com/Joaqim/dotfiles/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/Joaqim/dotfiles/actions/workflows/check.yml?query=branch%3Amain+)
[![Home Manager Status](https://github.com/Joaqim/dotfiles/actions/workflows/ci-home.yml/badge.svg?branch=main)](https://github.com/Joaqim/dotfiles/actions/workflows/ci-home.yml?query=branch%3Amain+)
[![Container Status](https://github.com/Joaqim/dotfiles/actions/workflows/container.yml/badge.svg?branch=main)](https://github.com/Joaqim/dotfiles/actions/workflows/container.yml?query=branch%3Amain+)

Credit to [https://github.com/kachick/dotfiles](https://github.com/kachick/dotfiles) for containerized home images

To enter shell of docker container built from [user@container](hosts/homes/user@container/default.nix) home configuration, run:
```shell
bash <(curl -fsSL 'https://github.com/Joaqim/dotfiles/raw/refs/heads/main/containers/sandbox-with-ghcr.bash') latest
```
Container might not work for systems other than `x86-64-linux`.

# TODO: A lot of theming from catppuccin is installed, even if the relevant application isn't enable

## Resources

[Nixcademy - Debugging Overlays using nix repl](https://nixcademy.com/posts/mastering-nixpkgs-overlays-techniques-and-best-practice/)

[NixOS/nixpkgs - How to override a Python Package?](https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md#how-to-override-a-python-package-how-to-override-a-python-package)

[Self hosted private github repository](https://ayats.org/blog/gitea-drone)

[Deyloying Gitea on NixOS](https://mcwhirter.com.au/craige/blog/2019/Deploying_Gitea_on_NixOS/)

[Useful Nix Hacks](http://www.chriswarbo.net/projects/nixos/useful_hacks.html)

## Inspirations

[Kachick/dotfiles](https://github.com/kachick/dotfiles)

[Derick Eddington's NixOS dotfiles](https://github.com/DerickEddington/nixos-config)

[TLATER/dotfiles - Sops secrets](https://github.com/TLATER/dotfiles/tree/e2432f2928ed2462852416dd54068f8c0c45dc6d#dotfiles)

[TLATER/dotfiles](https://github.com/TLATER/dotfiles)

[Misterio77/nix-config](https://github.com/Misterio77/nix-config)

[upRootNutrition/dotfiles](https://gitlab.com/upRootNutrition/dotfiles)

[Faupi/nixos-configs](https://github.com/Faupi/nixos-configs/tree/master)

[Wimpy's NixOS Configuration](https://github.com/wimpysworld/nix-config)

[Ambroisie's NixOS Configuration](https://github.com/ambroisie/nix-config)


