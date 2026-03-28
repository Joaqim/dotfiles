# NVF Debugging Skill

> Systematic debugging of NVF (Neovim Flake) configurations from Nix declaration to runtime state

## What This Skill Provides

This skill provides a complete methodology for debugging NVF/NeoVim configuration issues, tracing the full pipeline:

```
Nix Module → NVF Generator → init.lua → Plugin Setup → Runtime State
```

## When to Use

- Plugin configuration not applying
- `setupOpts` values not showing up at runtime
- Conflicts with upstream configs (timvim, astronvim, etc.)
- Understanding how Nix config translates to Lua
- Verifying what NVF actually generated

## Quick Start

```bash
# Complete debugging in 5 commands:

# 1. Find nvim package
NVIM_STORE=$(readlink -f $(which nvim) | xargs dirname | xargs dirname)

# 2. Get config directory
CONFIG_DIR=$(cat $NVIM_STORE/bin/nvim | grep -oP "(?<=source )[^']+(?='/init.lua')" | xargs dirname)

# 3. Find actual init.lua
ACTUAL_INIT=$(cat $CONFIG_DIR/init.lua | grep -oP "(?<=dofile\(')[^']+")

# 4. Check generated config
grep -A 20 "SECTION: your-plugin" $ACTUAL_INIT

# 5. Verify runtime
nvim --headless +"lua print(vim.inspect(require('your-plugin').state.config))" +qa 2>&1 | grep -v deprecated
```

## Skill Structure

### Main Skill (SKILL.md)

Core debugging methodology covering:
- The 8-step debugging chain
- Common issues and solutions
- Tools reference
- Quick start guide

### Workflows

Detailed guides for specific scenarios:

#### `workflows/tracing-setupOpts.md`
- setupOpts vs setup differences
- When setupOpts doesn't work
- Type conversions (Nix → Lua)
- Priority and overrides with mkForce/mkMerge

#### `workflows/runtime-inspection.md`
- Headless nvim execution for inspection
- Finding where plugins store config
- Handling late-loading/lazy plugins
- Creating inspection scripts
- Comparing expected vs actual state

#### `workflows/upstream-conflicts.md`
- Identifying conflicts with external configs (timvim, etc.)
- Resolution strategies (mkForce, mkMerge, replacement)
- Debugging module priority
- Real-world examples

## Key Techniques

### 1. Finding Generated Config

```bash
# The init.lua loaded by nvim
cat $(readlink -f $(which nvim)) | grep VIMINIT
# → /nix/store/xxx/init.lua

# The actual init.lua (follows dofile)
cat /nix/store/xxx/init.lua | grep dofile
# → /nix/store/yyy-init.lua (this is the real one)
```

### 2. Runtime Inspection

```bash
# Basic check
nvim --headless +"lua print(vim.inspect(require('plugin').config))" +qa 2>&1

# Check specific value
nvim --headless +"lua print(require('plugin').state.config.option)" +qa 2>&1

# Delayed (for lazy-loaded plugins)
nvim --headless +"lua vim.defer_fn(function() print(vim.inspect(...)); vim.cmd('qa!') end, 100)" 2>&1
```

### 3. Resolving Upstream Conflicts

```nix
# Complete override
extraPlugins.plugin.setup = lib.mkForce ''
  require('plugin').setup({ your = "config" })
'';

# Additive merge
extraPlugins.plugin.setupOpts = lib.mkMerge [
  { additional = "option"; }
];
```

## Common Debugging Patterns

### Plugin config not applying

1. ✓ Rebuilt home-manager? → `task hm -f`
2. ✓ Nvim package changed? → Check store path
3. ✓ Restarted nvim? → Old instances use old config
4. ✓ Generated Lua correct? → Check `$ACTUAL_INIT`
5. ✓ Runtime state matches? → Headless inspection

### setupOpts vs setup confusion

- **setupOpts** = Nix attrset, NVF converts to Lua
- **setup** = Raw Lua string, you write the setup() call

Use `setupOpts` for simple config, `setup` for complex Lua (functions, conditions).

### Upstream config winning

- Check if using `lib.mkForce`
- Verify module import order
- Ensure only ONE setup() call in generated init.lua

## Tools Reference

| Command | Purpose |
|---------|---------|
| `readlink -f $(which nvim)` | Find nvim store path |
| `cat wrapper \| grep VIMINIT` | Find config directory |
| `grep -A 20 "plugin" $ACTUAL_INIT` | Search generated config |
| `nvim --headless +"lua ..." +qa` | Runtime inspection |
| `nix eval --json ...setupOpts` | Check effective Nix value |

## Example: Complete Debugging Session

```bash
# Problem: claude-code command option not applying

# 1. Check Nix declaration
grep -A 10 "claudeCode" modules/home/nvf/default.nix
# Shows: claudeCode.command = "i"

# 2. Rebuild
task hm -f

# 3. Find generated config
NVIM_STORE=$(readlink -f $(which nvim) | xargs dirname | xargs dirname)
CONFIG_DIR=$(cat $NVIM_STORE/bin/nvim | grep -oP "(?<=source )[^']+(?='/init.lua')" | xargs dirname)
ACTUAL_INIT=$(cat $CONFIG_DIR/init.lua | grep -oP "(?<=dofile\(')[^']+")

# 4. Verify generated Lua
grep -A 15 "claude-code" $ACTUAL_INIT
# Shows: command = "i", ✓

# 5. Check runtime
nvim --headless +"lua print(require('claudecode').state.config.command)" +qa 2>&1
# Shows: i ✓

# Result: Configuration working correctly!
```

## Integration with Claude Code

This skill is automatically loaded when relevant keywords are detected in the conversation.

### Activation Triggers

The skill activates automatically when discussing:
- NVF or neovim configuration issues
- setupOpts not applying
- Plugin configuration debugging
- Nix-to-Lua translation problems

### Adding to Your Repository

Place this skill directory in your project's skills location (e.g., `AI/skills/` or `dotfiles/skills/`) where Claude Code can discover it.

## Related Skills

- `claude:nix` - General Nix/NixOS troubleshooting
- `claude:create-skill` - Creating new Claude Code skills

## Contributing

This skill was created from a real debugging session. Improvements welcome:

1. Additional common patterns
2. More upstream config examples
3. Plugin-specific debugging guides
4. Automation scripts

## License

Same as parent dotfiles repository (MIT).
