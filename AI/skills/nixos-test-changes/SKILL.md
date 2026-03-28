---
name: nixos-test-changes
description: Incremental NixOS/home-manager flake testing - only evaluate changed modules for 6-7x faster feedback. USE WHEN user says 'test my changes', 'quick test', 'incremental test', 'check what changed', 'test nixos config', or working on NixOS/home-manager configurations and needs fast validation.
---

# NixOS Incremental Testing

Fast, granular testing for NixOS flakes - only evaluate what changed.

## When to Activate This Skill

- User is working on NixOS or home-manager configuration changes
- User says "test my changes", "quick test", "incremental test"
- User asks "what changed" or "what needs testing"
- User wants faster feedback than full `task test` (~9s vs ~60s)
- User is in a NixOS configuration repository with `test-changes` app

## Core Workflow

### Quick Test (Recommended)

For fast iteration during development:

```bash
# 1. Make changes to config
vim hosts/homes/jq@desktop/default.nix

# 2. Quick incremental test (~9s)
task inc

# 3. If passes, full test before commit
task test
```

### Detailed Analysis

To see what's affected before testing:

```bash
# Analyze uncommitted changes
task test-changes
# or: nix run .#test-changes -- analyze

# Analyze all changes on branch
nix run .#test-changes -- analyze main

# Test specific changes
nix run .#test-changes -- test --eval-only
```

## Key Commands

```bash
# Quick incremental test (primary workflow)
task inc                                    # ~9s, tests only changed outputs

# Analyze what changed
task test-changes                           # Show affected outputs
nix run .#test-changes -- analyze          # Detailed change detection
nix run .#test-changes -- analyze main     # Changes vs main branch

# Testing commands
nix run .#test-changes -- test --eval-only # Evaluate changed outputs
nix run .#test-changes -- test --dry-run   # Show what would be tested
nix run .#test-changes -- compare          # Benchmark incremental vs full

# Build specific outputs
nix run .#test-changes -- build nixosConfigurations.desktop
nix run .#test-changes -- build --eval-only homeConfigurations.jq@desktop
```

## File-to-Output Mapping

The tool automatically maps changed files to specific flake outputs:

| Changed File Pattern | Affected Output | Test Speed |
|---------------------|----------------|------------|
| `hosts/nixos/desktop/*` | `nixosConfigurations.desktop` only | ~10s |
| `hosts/homes/jq@desktop/*` | `homeConfigurations.jq@desktop` only | ~9s |
| `hosts/homes/jq@qb/*` | `homeConfigurations.jq@qb` only | ~9s |
| `modules/nixos/*` | ALL configs (full test required) | ~60s |
| `modules/home/*` | ALL configs (full test required) | ~60s |
| `flake.nix`, `flake.lock` | ALL configs (full test required) | ~60s |
| `overlays/*`, `pkgs/*` | ALL configs (full test required) | ~60s |

## Common Patterns

### Pattern 1: Development Workflow (Host-Specific)

When changing a single host's configuration:

```bash
# 1. Make changes
vim hosts/homes/jq@desktop/default.nix

# 2. Quick test (~9s instead of ~60s)
task inc

# 3. Full test before push
task test
```

**Speedup**: 6.7x faster (9s vs 60s)

### Pattern 2: Feature Branch Testing

Test all changes on your branch before PR:

```bash
# See what changed
nix run .#test-changes -- analyze main

# Test all branch changes
nix run .#test-changes -- test main --eval-only

# Full test if incremental passes
task test
```

### Pattern 3: Module Changes (No Speedup)

When changing shared modules, full test is required:

```bash
# Edit shared module
vim modules/home/programs/git/default.nix

# Analyze detects ALL configs affected
task test-changes
# Output: "File 'modules/home/...' affects all configurations"

# Run full test (no shortcut available)
task test
```

### Pattern 4: Dry-Run Preview

See what would be tested without running:

```bash
# Preview without executing
nix run .#test-changes -- test --dry-run

# Shows commands that would run
# Useful for understanding impact
```

## Performance Benchmarks

| Scenario | Full Test | Incremental | Speedup |
|----------|-----------|-------------|---------|
| Single home config | ~60s | ~9s | 6.7x |
| Single NixOS host | ~60s | ~10s | 6x |
| Two hosts | ~60s | ~18s | 3.3x |
| Shared module | ~60s | ~60s | 1x (must test all) |

## Flags

- `--eval-only` / `-e` - Only evaluate, don't build (faster, recommended)
- `--dry-run` / `-n` - Show commands without executing
- `analyze [base]` - Detect changes (base defaults to HEAD)
- `test [base]` - Run incremental test
- `compare [base]` - Benchmark incremental vs full
- `build <outputs>` - Build specific outputs

## Environment Variables

```bash
# Enable dry-run mode
DRY_RUN=true nix run .#test-changes -- test

# Enable eval-only mode
EVAL_ONLY=true nix run .#test-changes -- test
```

## Examples

```bash
# Example 1: Quick iteration
vim hosts/homes/jq@desktop/default.nix
task inc                                    # 9s test

# Example 2: Multiple host changes
vim hosts/nixos/desktop/hardware.nix
vim hosts/nixos/qb/profiles.nix
nix run .#test-changes -- analyze          # Shows both affected
nix run .#test-changes -- test --eval-only # Tests both (~20s)

# Example 3: Branch comparison
git checkout -b feature/new-module
# ... make changes ...
nix run .#test-changes -- analyze main     # All changes vs main
nix run .#test-changes -- test main        # Test all changes

# Example 4: Specific host testing
nix run .#test-changes -- build --eval-only \
  nixosConfigurations.desktop \
  homeConfigurations.jq@desktop

# Example 5: CI/CD workflow
nix run .#test-changes -- test origin/main --eval-only
```

## When NOT to Use

- **Changing shared modules** - Use `task test` directly (no speedup possible)
- **Before final commit** - Always run full `task test` before pushing
- **Building actual outputs** - Use `task nixos` or `task home-manager` for activation
- **CI/CD final validation** - Use full test suite for merge validation

## Integration with Existing Workflow

The incremental testing complements, doesn't replace, full testing:

```bash
# Development cycle
task inc              # Fast iteration (9s)
task inc              # Test again
task inc              # Keep iterating

# Before commit
task test            # Full validation (60s)
git commit -m "..."

# Activation
task apply           # Apply both NixOS and home-manager
```

## Troubleshooting

**"No changes detected"**
- You have no uncommitted changes
- Solution: Make changes or specify different base with `analyze main`

**"No outputs affected by changes"**
- Changed files don't map to any flake outputs (e.g., README, scripts)
- Solution: This is fine, no testing needed for those files

**"FULL_CHECK required"**
- Changed files affect shared modules/overlays/packages
- Solution: Run `task test` for full validation

**Test fails but full test passes**
- Rare edge case with dependency detection
- Solution: Always run full `task test` before committing

## Key Principles

1. **Use incremental for iteration** - 6-7x faster feedback during development
2. **Always full test before push** - Ensure everything still works together
3. **Understand the mapping** - Host-specific = fast, shared = full test
4. **Trust the detection** - Tool accurately maps files to outputs
5. **Eval-only is enough** - Build only needed for final activation

## Supplementary Resources

For implementation details: `read apps/test-changes/README.md`
For app source: `read apps/test-changes/test-changes.sh`
For Taskfile integration: `read Taskfile.yml`
