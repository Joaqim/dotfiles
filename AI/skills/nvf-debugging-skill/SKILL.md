---
name: nvf-debug
description: Debug NVF (Neovim Flake) configurations by tracing from Nix modules to generated Lua to runtime state. USE WHEN troubleshooting nvf/neovim configuration issues, plugin setupOpts not applying, or understanding how Nix config translates to runtime behavior.
---

# NVF Configuration Debugging

Debug NVF (nvf - Neovim Flake Framework) configurations by systematically tracing from Nix module declarations through generated Lua configuration to actual runtime state.

## When to Activate This Skill

- User says NVF/nvf/neovim configuration "isn't working" or "not applying"
- Plugin setupOpts or configuration not taking effect
- Need to verify what NVF actually generated
- Debugging conflicts between nvf modules or upstream configs
- Understanding how Nix config translates to Lua/runtime
- Tracing configuration from declaration to execution

## Quick Start - Complete Debugging Flow

```bash
# 1. Find the nvim store path
NVIM_STORE=$(readlink -f $(which nvim) | xargs dirname | xargs dirname)

# 2. Extract config directory from wrapper
CONFIG_DIR=$(cat $NVIM_STORE/bin/nvim | grep -oP "(?<=source )[^']+(?='/init.lua')" | xargs dirname)

# 3. Find the actual init.lua (follows dofile chain)
ACTUAL_INIT=$(cat $CONFIG_DIR/init.lua | grep -oP "(?<=dofile\(')[^']+")

# 4. Search for your plugin/config section
grep -A 20 "SECTION: your-plugin" $ACTUAL_INIT

# 5. Verify runtime state
nvim --headless +"lua print(vim.inspect(require('your-plugin').state.config))" +qa 2>&1 \
  | grep -v "deprecated\|stopped"
```

## Core Debugging Chain

The debugging process follows the configuration flow from source to execution:

**Nix Module → NVF Generator → init.lua → Plugin Setup → Runtime State**

### 1. Read Your NVF Module Configuration

Start by understanding what you're declaring in Nix.

```bash
# Read your nvf module
cat modules/home/nvf/default.nix

# Read host-specific configuration
cat hosts/homes/$USER@$(hostname)/default.nix
```

**Look for:**
- Module options (e.g., `my.home.nvf.pluginName.option = value`)
- How config is passed to nvf (via `setupOpts`, `setup`, or `extraConfig`)
- Use of `lib.mkForce`, `lib.mkDefault`, or other priority overrides
- External inputs/configs being imported (timvim, astronvim, etc.)

### 2. Locate NeoVim Package

Find where the built neovim package lives in the Nix store.

```bash
# Method 1: Via which
readlink -f $(which nvim)
# → /nix/store/xxx-mnw-0.11.6/bin/nvim

# Method 2: Get package root
readlink -f $(which nvim) | xargs dirname | xargs dirname
# → /nix/store/xxx-mnw-0.11.6
```

### 3. Analyze the Wrapper Script

The nvim executable is a wrapper that sets environment and config paths.

```bash
cat $(readlink -f $(which nvim))
```

**Extract critical info:**
- `VIMINIT='source /nix/store/xxx/init.lua'` - Main config location
- `NVIM_APPNAME='nvf'` - App name (affects runtime paths)
- `--cmd "lua vim.opt.packpath:prepend(...)"` - Additional config paths

### 4. Read Generated init.lua

NVF generates Lua from your Nix modules. The wrapper points to the config.

```bash
# Get config dir from wrapper
CONFIG_DIR=$(cat $(readlink -f $(which nvim)) | grep -oP "(?<=source )[^']+(?='/init.lua')" | xargs dirname)

# Read main init.lua
cat $CONFIG_DIR/init.lua
```

**Common pattern:** The init.lua often does:
```lua
dofile('/nix/store/yyy-init.lua')
```

This is the ACTUAL config file with all your settings.

### 5. Follow the dofile() Chain

```bash
# Extract the dofile path
ACTUAL_INIT=$(cat $CONFIG_DIR/init.lua | grep -oP "(?<=dofile\(')[^']+")

# Read the real configuration
cat $ACTUAL_INIT

# Search for specific plugin
grep -A 20 "SECTION: plugin-name" $ACTUAL_INIT
grep -A 20 "require.*plugin-name.*setup" $ACTUAL_INIT
```

**Verify:**
- ✓ Is your config section present?
- ✓ Are Nix variables interpolated correctly? (e.g., `command = "i"`)
- ✓ Are there multiple `setup()` calls for the same plugin?
- ✓ Does the generated Lua match your Nix declaration?

### 6. Check for Upstream Config Conflicts

If using external nvf configs (timvim, astronvim, etc.), they may define conflicting plugin configs.

```bash
# Find external config source from flake.lock
jq -r '.nodes.timvim.locked | "\(.owner)/\(.repo) @ \(.rev[0:7])"' flake.lock

# Clone and search
cd /tmp
git clone --depth 1 https://github.com/owner/repo external-config
find external-config/config -name "*.nix" -exec grep -l "plugin-name" {} \;

# Read the conflicting config
cat external-config/config/path/to/plugin.nix
```

**Check for:**
- Different `setup()` or `setupOpts` configurations
- Missing options in upstream config
- Module priority (are you using `mkForce` to override?)

### 7. Verify Runtime State

Finally, check what NeoVim actually loaded at runtime.

```bash
# Basic config inspection
nvim --headless +"lua print(vim.inspect(require('plugin').config))" +qa 2>&1

# Check .state.config (common pattern)
nvim --headless +"lua print(vim.inspect(require('plugin').state.config))" +qa 2>&1

# Check specific option
nvim --headless +"lua local cfg = require('plugin').state.config; print('option:', cfg.your_option)" +qa 2>&1

# Inspect entire module with delay (for late-loading plugins)
nvim --headless +"lua vim.defer_fn(function() print(vim.inspect(require('plugin'))); vim.cmd('qa!') end, 100)" 2>&1

# Filter noise
nvim --headless +"lua ..." +qa 2>&1 | grep -v "deprecated\|stopped\|lspconfig"
```

### 8. Count Configuration Calls

Ensure plugin isn't configured multiple times (last call wins).

```bash
# Count setup calls
grep -n "plugin.*setup" $ACTUAL_INIT

# Show all setup sections
grep -B 5 -A 15 "require.*plugin.*setup" $ACTUAL_INIT
```

## Common Issues & Solutions

### Configuration Not Applying

**Symptoms:** Changed setupOpts in Nix but runtime behavior unchanged.

**Debug steps:**
1. Rebuild home-manager: `task hm -f` or `home-manager switch --flake .`
2. Check nvim store path changed (indicates rebuild happened)
3. Restart any running nvim instances
4. Verify generated init.lua has your changes
5. Check runtime state confirms changes

### setupOpts vs setup Confusion

**`setupOpts`** (NVF pattern):
- Takes a Nix attrset
- NVF converts to Lua and calls `require('plugin').setup()`
- Example: `extraPlugins.plugin-name.setupOpts = { option = true; };`

**`setup`** (Raw Lua):
- Takes a Lua string directly
- You write the `require().setup()` call yourself
- Example: `extraPlugins.plugin-name.setup = ''require('plugin').setup({ option = true })'';`

**When setupOpts doesn't work:** Plugin might need raw Lua for complex config.

### Option Showing as nil at Runtime

**Possible causes:**
1. Plugin stores config elsewhere (not `.config` or `.state.config`)
2. Setup hasn't run yet (timing/load order issue)
3. Typo in option name or wrong format
4. Plugin expects different structure (table vs string, etc.)

**Debug:**
```bash
# Inspect entire plugin module to find where config lives
nvim --headless +"lua print(vim.inspect(require('plugin')))" +qa 2>&1 | less
```

### Multiple Configs Conflicting

**Symptoms:** Config partially applying or wrong values.

**Common cause:** Upstream config (timvim, etc.) defines plugin setup, your override is wrong priority.

**Solution:**
```nix
# Use mkForce to override completely
extraPlugins.plugin.setup = lib.mkForce ''
  require('plugin').setup({ your = "config" })
'';
```

**Verify in init.lua:** Should be only ONE setup call with YOUR config.

### Nix Variable Interpolation Not Working

**Check:**
- Variable in scope? (is `cfg` defined in let-block?)
- Escaping: use `''${var}''` for Nix interpolation in multiline strings
- Type conversion: bools need `if b then "true" else "false"` for Lua

**Example:**
```nix
let
  cfg = config.my.home.nvf;
  toLua = b: if b then "true" else "false";
in
setup = ''
  require('plugin').setup({
    command = "${cfg.command}",  -- String interpolation
    enabled = ${toLua cfg.enable},  -- Bool to Lua bool
  })
'';
```

## Advanced Workflows

See `workflows/` for detailed guides:

- `tracing-setupOpts.md` - Deep dive on setupOpts vs setup
- `debugging-timvim-conflicts.md` - Handling upstream config conflicts
- `runtime-inspection.md` - Advanced runtime debugging techniques

## Tools Reference

| Task | Command |
|------|---------|
| Find nvim package | `readlink -f $(which nvim) \| xargs dirname \| xargs dirname` |
| Get config directory | `cat $(readlink -f $(which nvim)) \| grep VIMINIT` |
| Find actual init.lua | `cat $CONFIG_DIR/init.lua \| grep dofile` |
| Search generated config | `grep -A 20 "plugin" $ACTUAL_INIT` |
| Count setup calls | `grep -n "plugin.*setup" $ACTUAL_INIT` |
| Runtime inspection | `nvim --headless +"lua print(...)" +qa` |
| Clone upstream config | `git clone --depth 1 <url> /tmp/check` |

## Related Skills

- `claude:nix` - General Nix/NixOS/home-manager troubleshooting
- `claude:create-skill` - Creating new Claude Code skills
