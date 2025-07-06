https://wiki.nixos.org/wiki/Platformio
https://unix.stackexchange.com/questions/768678/configure-vscode-in-nixos

- Add automatic tailscale authentication using non-expiring key in nixos/modules/tailscale.nix
- Is `home.packages = [gvfs]` redundant while using `services.gvfs.enable` ?
- Move `fcitx5` configuration from `nixos/modules/locale.nix`
- Move `liquidctl` dependant `gamemode` from `nixos/modules/gamemode.nix`
- Rename `nixos/modules/atuin.nix` to `atuin-host.nix`, all other systems except `desktop` should use `homeModules.atuin` instead ( bundled in `homeModules.commandLine`. )
- Expand `nixos/modules/tailscale.nix` configuration with [Tailscale Nixos Module](https://github.com/adwinying/dotfiles/commit/cd3b0bf3e1e88bd145faf4842df2c8d04189b9b5#diff-1b812d039c8e6567386e8ded11cdc27d9d7e77aaa998495df82bcc7f9e855b65R48)
- Parse existing `steam` shortcuts: [https://gist.github.com/Joaqim/473c1663bc42e8846c69a94b525a27ff](https://gist.github.com/Joaqim/473c1663bc42e8846c69a94b525a27ff)
- Minecraft server as a nixos service: [MayNiklas/nixos - modules/minecraft](https://github.com/MayNiklas/nixos/blob/main/modules/minecraft/default.nix)
- my.system.doas doesn't seem to apply `noPass` for selected programs
- Fix: 
```log
setlocale "en_SE.UTF-8": No such file or directory
pv-locale-gen: Missing locale en_SE.UTF-8 (found in $LC_MEASUREMENT)
```
- Implement [my.services.sunshine](https://github.com/Joaqim/dotfiles/commit/3aea9d5498978f20287f11b3678a686cf63b58e7)

- Fix LC_TIME output: `2025-06-27 07:33:57,878`; I prefer dots over commas for decimal points 
- Make sure `steam` uses `bash` as its default shell, have seen `nushell` be used for steam launch commands


- Investigate fcitx5 failing on many apps: 
```
(faugus-launcher:169233): Gtk-WARNING **: 00:11:52.055: Loading IM context type 'fcitx' failed
(faugus-launcher:169233): Gtk-WARNING **: 00:11:52.055: GModule (/nix/store/lnqv0r2wa8s248yk3lrr9hhxfl1n6knv-fcitx5-with-addons-5.1.12/lib/gtk-3.0/3.0.0/immodules/im-fcitx5.so) initialization check failed: GLib version too old (micro mismatch
```