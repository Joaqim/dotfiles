# Incremental Flake Testing

Fast, granular testing for Nix flakes - only evaluate what changed.

## Overview

`test-changes` is a flake app that detects which files changed in your flake and builds/evaluates only the affected outputs. This dramatically speeds up the feedback loop during development.

Packaged as a proper Nix application using `writeShellApplication` with ShellCheck linting.

## Quick Start

```bash
# Analyze what changed
nix run .#test-changes -- analyze
# or: task test-changes

# Test only changed outputs (fast, ~9s)
task inc
# or: nix run .#test-changes -- test --eval-only

# Compare with full test (~60s)
time task test
```

## Commands

### `analyze [base]`
Analyze changed files and show which outputs are affected.

```bash
# Check uncommitted changes
nix run .#test-changes -- analyze
# or: task test-changes

# Check changes against main branch
nix run .#test-changes -- analyze main
```

### `test [base]`
Run incremental build/eval test with timing.

```bash
# Test uncommitted changes (fast eval)
nix run .#test-changes -- test --eval-only
# or: task inc

# Test all changes on current branch
nix run .#test-changes -- test main

# Dry-run to see what would be tested
nix run .#test-changes -- test --dry-run
```

### `compare [base]`
Compare incremental vs full build times.

```bash
nix run .#test-changes -- compare
```

### `build <outputs...>`
Build or evaluate specific outputs.

```bash
nix run .#test-changes -- build nixosConfigurations.desktop
nix run .#test-changes -- build --eval-only homeConfigurations.jq@desktop
```

## Flags

- `--eval-only`, `-e` - Only evaluate, don't build (much faster, ~9s vs ~60s)
- `--dry-run`, `-n` - Show commands without executing

## Taskfile Integration

```bash
# Quick incremental test (recommended)
task test-incremental  # or: task inc

# Show what changed
task test-changes

# Full test (slower, tests everything)
task test
```

## How It Works

### File-to-Output Mapping

The tool maps changed files to specific flake outputs:

| Changed File | Affected Output |
|--------------|----------------|
| `hosts/nixos/desktop/*` | `nixosConfigurations.desktop` |
| `hosts/homes/jq@desktop/*` | `homeConfigurations.jq@desktop` |
| `modules/nixos/*` | ALL (requires full check) |
| `modules/home/*` | ALL (requires full check) |
| `flake.nix`, `flake.lock` | ALL (requires full check) |
| `overlays/*`, `pkgs/*` | ALL (requires full check) |

### Granularity Levels

1. **Single host** - Only that host's configuration (~9s eval)
2. **Multiple hosts** - Only affected hosts (~9s per host)
3. **Full check** - All configurations (~60s+ eval)

## Performance

### Evaluation Times (--eval-only)

- **Single home-manager config**: ~9s
- **Single NixOS config**: ~10-15s
- **All configs (full test)**: ~60-90s

### Speedup Examples

| Scenario | Full Test | Incremental | Speedup |
|----------|-----------|-------------|---------|
| Change one host config | 60s | 9s | 6.7x |
| Change two host configs | 60s | 18s | 3.3x |
| Change shared module | 60s | 60s | 1x (must test all) |

## Examples

### Development Workflow

```bash
# 1. Make changes to a host config
vim hosts/homes/jq@desktop/default.nix

# 2. Quick test (~9s)
task inc

# 3. If it passes, do full test before committing
task test
```

### Testing a Feature Branch

```bash
# See all changes on branch
nix run .#test-changes -- analyze main

# Test all branch changes
nix run .#test-changes -- test main --eval-only
```

### CI/CD Integration

```bash
# In CI, test only what changed since main
nix run .#test-changes -- test origin/main --eval-only
```

## Environment Variables

```bash
# Enable dry-run mode
DRY_RUN=true nix run .#test-changes -- test

# Enable eval-only mode
EVAL_ONLY=true nix run .#test-changes -- test
```

## Implementation

Located in `apps/test-changes/`:
- `default.nix` - Nix package definition using `writeShellApplication`
- `test-changes.sh` - Main shell script (ShellCheck validated)

The app is auto-discovered by the flake's `apps` output via `mapModules`.

## Tips

1. **Use `--eval-only` for development** - It's 6x faster than building
2. **Run full test before pushing** - Ensures everything still works
3. **Test against `main`** - See all changes on your feature branch
4. **Use `task inc`** - Shortest command for quick feedback

## Limitations

- Changes to shared modules trigger full evaluation (as they should)
- Git-tracked files only (unless uncommitted)
- Requires valid git repository
- Mappings hardcoded (edit script to add new hosts)

## Future Improvements

- [ ] Auto-detect all hosts from flake outputs
- [ ] Cache evaluation results
- [ ] Parallel evaluation of independent outputs
- [ ] Integration with pre-commit hooks
- [ ] Support for package-only changes (even faster)
