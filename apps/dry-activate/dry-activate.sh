#!/usr/bin/env sh
# Based on: https://github.com/kachick/dotfiles/blob/main/scripts/dry.bash
set -exo pipefail

if [ -f '/etc/NIXOS' ]; then
    # Prefer `build` rather than `test` and `dry-reactivate` for the speed and not requiring root permissions
    nixos-rebuild build --flake ".#$(hostname)" --show-trace
fi

_HOME_CONF=".#$USER"
if [ ! -z "$HM_HOST_SLUG" ]; then
    _HOME_CONF+="@$HOSTNAME"
fi

nix run '.#home-manager' -- switch --dry-run -b backup --show-trace --flake $_HOME_CONF