#!/usr/bin/env sh

set -eu

TMPDIR="$(mktemp -d -t nvfetcher-XXXXXX)"

cd "$(git rev-parse --show-toplevel)/pkgs" || exit 1
nvfetcher -l "${TMPDIR}/changelog" "$@"
cat <<EOF > "${TMPDIR}/commit-summary"
bump(pkgs): nvfetcher: Update \`./pkgs/sources.nix\`

EOF

if [ -s "${TMPDIR}/changelog" ]; then
    cat "${TMPDIR}/commit-summary" "${TMPDIR}/changelog" > "${TMPDIR}/commit-message"
    git add _sources/
    git commit _sources/ -F "${TMPDIR}/commit-message"
else
    # Clean up any debris nvfetcher may leave in its database.
    #
    # This should be "safe", since nvfetcher will override whatever
    # the user had previously anyway, so at least it won't break
    # anything further than running nvfetcher already did.
    git restore _sources/
fi

rm -r "${TMPDIR}"