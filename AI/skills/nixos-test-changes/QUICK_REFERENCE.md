# NixOS Incremental Testing - Quick Reference

## The 3-Second Version

```bash
task inc        # Test changes in 9s instead of 60s
```

## Common Commands

| Command | Speed | Use When |
|---------|-------|----------|
| `task inc` | ~9s | Changed one host config |
| `task test-changes` | <1s | See what's affected |
| `task test` | ~60s | Before commit (full validation) |

## Decision Tree

```
Changed files?
├─ Single host config → task inc (9s)
├─ Module/overlay → task test (60s, no shortcut)
└─ Multiple hosts → nix run .#test-changes -- test (18s)
```

## Workflow

1. **Edit** → `vim hosts/homes/jq@desktop/default.nix`
2. **Quick test** → `task inc` (9s)
3. **Iterate** → Repeat 1-2 until working
4. **Full test** → `task test` (60s, before commit)
5. **Commit** → `git commit`

## When Things Break

- **"No changes"** → You forgot to save
- **"FULL_CHECK"** → You edited shared module, use `task test`
- **Test fails** → Check error, or run `task test` for full trace

## Performance

- Single host: **6.7x faster** (9s vs 60s)
- Two hosts: **3.3x faster** (18s vs 60s)
- Module change: **1x** (must test all, 60s)

## Pro Tips

1. Use `task inc` liberally during development
2. Always `task test` before `git push`
3. Use `--dry-run` to preview without executing
4. Compare times: `nix run .#test-changes -- compare`
