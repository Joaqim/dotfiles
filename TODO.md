https://wiki.nixos.org/wiki/Platformio
https://unix.stackexchange.com/questions/768678/configure-vscode-in-nixos

- Add automatic tailscale authentication using non-expiring key in nixos/modules/tailscale.nix
- Is `home.packages = [gvfs]` redundant while using `services.gvfs.enable` ?
- Move `fcitx5` configuration from `nixos/modules/locale.nix`
- Move `liquidctl` dependant `gamemode` from `nixos/modules/gamemode.nix`
- Rename `nixos/modules/atuin.nix` to `atuin-host.nix`, all other systems except `desktop` should use `homeModules.atuin` instead ( bundled in `homeModules.commandLine`. )
- Expand `nixos/modules/tailscale.nix` configuration with [Tailscale Nixos Module](https://github.com/adwinying/dotfiles/commit/cd3b0bf3e1e88bd145faf4842df2c8d04189b9b5#diff-1b812d039c8e6567386e8ded11cdc27d9d7e77aaa998495df82bcc7f9e855b65R48)
- Parse existing `steam` shortcuts: [https://gist.github.com/Joaqim/473c1663bc42e8846c69a94b525a27ff](https://gist.github.com/Joaqim/473c1663bc42e8846c69a94b525a27ff)

## systems/node

# GPU Passthrough to Windows VM
- https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
- https://github.com/HarbourHeading/KVM-GPU-Passthrough
- https://discourse.nixos.org/t/single-gpu-passthrough/44119/3