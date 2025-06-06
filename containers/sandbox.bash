#!/usr/bin/env -S bash

set -euo pipefail

sandbox() {
	local -r container_id="$(podman run --detach --rm localhost/provisioned-systemd-home)"
	# shellcheck disable=SC2064
	trap "podman kill '$container_id'" EXIT ERR
	sleep 1 # Wait for the systemd to be ready
	podman exec --user=user --workdir='/home/user' -eTERM -it "$container_id" '/home/user/.nix-profile/bin/nu'
}

sandbox