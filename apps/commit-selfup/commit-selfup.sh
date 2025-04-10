#!/usr/bin/env sh
git ls-files .github | xargs selfup run
if [ "$(git status --porcelain | wc -l)" -gt 0 ]; then
    git commit -m "bump(ci): Update workflow dependencies using \`selfup\`" .github
fi