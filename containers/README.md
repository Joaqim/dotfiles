# Containers

Copied from: [Kachick's dotfiles](https://github.com/kachick/dotfiles)

Base images are maintained in [another repository](https://github.com/kachick/containers)

## How to build and test in local

```bash
podman build --tag nix-systemd --file containers/Containerfile .
container_id="$(podman run --detach --rm localhost/nix-systemd:latest)"
podman exec --user=user -it "$container_id" /provisioner/needs_systemd.bash
podman exec --user=root -it "$container_id" rm -rf /provisioner
podman commit "$container_id" provisioned-systemd-home
podman kill "$container_id"
```

Since now, we can reuse the image as this

```bash
container_id="$(podman run --detach --rm localhost/provisioned-systemd-home)"
podman exec --user=user --workdir='/home/user' -it "$container_id" /home/user/.nix-profile/bin/nu

# You can use the container here
# ~ nu
# > la -a .config
╭────┬────────────────────────┬─────────┬──────┬────────────────╮
│  # │          name          │  type   │ size │    modified    │
├────┼────────────────────────┼─────────┼──────┼────────────────┤
│  0 │ .config/atuin          │ dir     │  3 B │ an hour ago    │
│  1 │ .config/bat            │ dir     │  4 B │ an hour ago    │
│  2 │ .config/bottom         │ dir     │  3 B │ an hour ago    │
│  3 │ .config/direnv         │ dir     │  3 B │ an hour ago    │
│  4 │ .config/environment.d  │ dir     │  3 B │ an hour ago    │
│  5 │ .config/git            │ dir     │  4 B │ an hour ago    │
│  6 │ .config/lesskey        │ symlink │ 78 B │ an hour ago    │
│  7 │ .config/mimeapps.list  │ symlink │ 84 B │ an hour ago    │
│  8 │ .config/nushell        │ dir     │  3 B │ 17 minutes ago │
│  9 │ .config/systemd        │ dir     │  3 B │ an hour ago    │
│ 10 │ .config/user-dirs.conf │ symlink │ 85 B │ an hour ago    │
│ 11 │ .config/user-dirs.dirs │ symlink │ 85 B │ an hour ago    │
│ 12 │ .config/wgetrc         │ symlink │ 77 B │ an hour ago    │
│ 13 │ .config/zellij         │ dir     │  3 B │ an hour ago    │
╰────┴────────────────────────┴─────────┴──────┴────────────────╯

podman kill "$container_id"
```
