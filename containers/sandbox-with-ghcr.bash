#!/usr/bin/env -S bash

## Use Process Substitution for this script
# - https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html
# - https://qiita.com/takei-yuya@github/items/7afcb92cfe7e678b7f6d
#
# bad: cmd | bash -s - arg
# good: bash <(cmd) arg

set -euxo pipefail

cat <<'EOF'
============
if you encounter errors, may need following setup

# https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
echo $GHCR_PULL_TOKEN | podman login ghcr.io -u YOUR_USERNAME --password-stdin
============
EOF

sandbox() {
	local -r tag="$1"
	local -r full_image_id="$(podman pull "ghcr.io/joaqim/home:${tag}")"
	if [ -z "$full_image_id" ]; then
		exit 1
	fi
	local -r container_id="$(podman run --detach --rm "$full_image_id")"
	# shellcheck disable=SC2064
	trap "podman kill '$container_id'" EXIT ERR
	sleep 1 # Wait for the systemd to be ready
	podman exec --user=user --workdir='/home/user' -eTERM -it "$container_id" '/home/user/.nix-profile/bin/nu'
}

sandbox "$1"