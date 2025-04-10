#!/usr/bin/env sh
git ls-files .github | xargs nix develop --command selfup run
if [ $(git status --porcelain | wc -l) -gt 0 ]; then
    echo "changed=true" | tee -a "$GITHUB_OUTPUT"
    git commit -m 'bump(ci): Update workflow dependencies using `selfup`' .github
fi