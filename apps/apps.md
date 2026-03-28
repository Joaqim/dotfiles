# Apps

Submodules in `./apps/<application-name>` are expected to return path to application executable as string.

Will become:
```nix
perSystem.${system}.apps.<application-name> = {
    type = "app";
    program = "/nix/store/<path-to-executable>";
};
```

## Available Apps

### test-changes
**Incremental flake testing** - Only evaluate changed modules for faster development feedback.

```bash
# Quick test (recommended workflow)
task inc                              # ~9s for single config

# Full analysis
nix run .#test-changes -- analyze     # See what changed
nix run .#test-changes -- test --eval-only
nix run .#test-changes -- compare     # Benchmark incremental vs full

# See: apps/test-changes/README.md
```

**Performance**: 6-7x faster than full test when only host-specific files changed.

### Other Apps
- `dry-activate` - Dry-activate NixOS and home-manager configuration
- `home-manager` - Home Manager activation
- `commit-flake-lock`, `commit-selfup`, `commit-nvfetcher` - Update and commit dependencies
- And more... (see app directories)