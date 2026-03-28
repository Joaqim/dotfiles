# Debugging Upstream Config Conflicts

How to identify and resolve conflicts when using external nvf configurations (timvim, astronvim, nvim-starter, etc.) that also configure your plugins.

## Understanding the Problem

When you import external nvf configs, they often pre-configure popular plugins. Your local overrides might not apply due to:

1. **Module priority** - Upstream config wins over yours
2. **Wrong override method** - Using `mkDefault` when you need `mkForce`
3. **Multiple setup calls** - Both configs run, last one wins
4. **Incomplete override** - You only override part of the config

## Identifying Upstream Conflicts

### Step 1: Find External Config Sources

Check which external configs you're importing.

```bash
# From your nvf module
grep -n "inputs\." modules/home/nvf/default.nix | grep -E "timvim|astronvim|nvim-"

# Example output:
# "${inputs.timvim}/config"
```

### Step 2: Locate the External Config

```bash
# Get source info from flake.lock
jq -r '.nodes.timvim.locked | "\(.owner)/\(.repo) @ \(.rev)"' flake.lock

# Clone it for inspection
cd /tmp
git clone --depth 1 https://github.com/owner/repo external-config
cd external-config
```

### Step 3: Search for Your Plugin

```bash
# Find all files configuring your plugin
find config -name "*.nix" -exec grep -l "plugin-name" {} \;

# Example output:
# config/assistant/plugin-name.nix
# config/core/extra-plugins.nix
```

### Step 4: Read the Upstream Config

```bash
cat config/assistant/plugin-name.nix
```

**Look for:**
- What setupOpts or setup values they set
- If they use `mkDefault`, `mkForce`, or nothing (highest priority)
- What options they DON'T set (you can add these without conflict)

## Resolving Conflicts

### Strategy 1: mkForce for Complete Override

**When to use:** You want COMPLETELY different config than upstream.

```nix
# Without mkForce - may not override
extraPlugins.plugin-name.setupOpts = {
  your = "config";
};

# With mkForce - guaranteed override
extraPlugins.plugin-name.setupOpts = lib.mkForce {
  your = "config";
};
```

**Verify it worked:**
```bash
# Check generated init.lua - should have ONLY your config
ACTUAL_INIT=$(cat $(cat $(readlink -f $(which nvim)) | grep -oP "(?<=source )[^']+(?='/init.lua')") | grep -oP "(?<=dofile\(')[^']+")
grep -A 20 "plugin-name" $ACTUAL_INIT
```

### Strategy 2: mkMerge for Additive Config

**When to use:** Upstream config is mostly good, you want to add to it.

```nix
extraPlugins.plugin-name.setupOpts = lib.mkMerge [
  # Upstream's config is preserved
  {
    your_additional_option = "value";
    override_this_one = lib.mkForce "new value";
  }
];
```

### Strategy 3: Replace setup, Not setupOpts

**When to use:** Upstream uses `setupOpts`, you need raw Lua control.

```nix
# Upstream has setupOpts, you replace with raw setup
extraPlugins.plugin-name = {
  # Clear upstream's setupOpts
  setupOpts = lib.mkForce {};

  # Use your raw setup
  setup = lib.mkForce ''
    require('plugin-name').setup({
      -- Your complete Lua config
    })
  '';
};
```

### Strategy 4: Disable Upstream Plugin

**When to use:** You want to configure the plugin completely separately.

```nix
# Disable upstream's plugin config
extraPlugins.plugin-name.enable = lib.mkForce false;

# Configure it yourself elsewhere
extraPlugins.my-custom-plugin-name = {
  package = pkgs.vimPlugins.plugin-name;
  setup = ''
    require('plugin-name').setup({ ... })
  '';
};
```

## Debugging Priority Issues

### Check Module Import Order

The order matters! Later imports can override earlier ones.

```nix
# In your nvf module
modules = [
  "${inputs.timvim}/config"  # Loaded first
  {
    # Your overrides here - loaded second (can override timvim)
    vim.extraPlugins.plugin.setupOpts = lib.mkForce { ... };
  }
];
```

### Evaluate Effective Configuration

See what value actually wins after all merges.

```bash
# Evaluate the final setupOpts value
nix eval --json .#homeConfigurations.$(whoami)@$(hostname).config.programs.nvf.settings.vim.extraPlugins.plugin-name.setupOpts

# Trace where the value comes from
nix eval --show-trace .#homeConfigurations.$(whoami)@$(hostname).config.programs.nvf.settings.vim.extraPlugins.plugin-name.setupOpts 2>&1 | grep -A 5 "defined"
```

## Real Example: Resolving claude-code Conflict

### Problem

Timvim configures claude-code without a `command` option. You want to add it.

**Upstream config (timvim/config/assistant/claude-code.nix):**
```nix
extraPlugins.claude-code.setup = ''
  require('claudecode').setup({
    server = { host = "localhost", port = 9000 },
    auto_start = true,
  })
'';
```

**Your desired config:**
```nix
# You want to ADD command option
command = "i",
```

### Solution Attempts

**Attempt 1: Just set it (FAILS)**
```nix
# This won't work - upstream's setup still runs, yours is ignored
extraPlugins.claude-code.setupOpts = {
  command = "i";
};
```

**Why it fails:** Upstream uses raw `setup`, not `setupOpts`. They're different attributes.

**Attempt 2: Override setup without mkForce (FAILS)**
```nix
# This won't work - upstream's setup has equal/higher priority
extraPlugins.claude-code.setup = ''
  require('claudecode').setup({
    server = { host = "localhost", port = 9000 },
    auto_start = true,
    command = "i",
  })
'';
```

**Why it fails:** Without `mkForce`, upstream config might win.

**Attempt 3: mkForce the setup (WORKS!)**
```nix
extraPlugins.claude-code.setup = lib.mkForce ''
  require('claudecode').setup({
    server = { host = "localhost", port = 9000 },
    auto_start = true,
    command = "${cfg.claudeCode.command}",  -- Added command
  })
'';
```

**Verify:**
```bash
# Generated init.lua should have command
grep -A 15 "claude-code" $ACTUAL_INIT | grep "command"
# Output: command = "i",

# Runtime should have command
nvim --headless +"lua print(require('claudecode').state.config.command)" +qa 2>&1
# Output: i
```

## Multiple setup() Calls

If both your config and upstream's config end up in init.lua:

```lua
-- Upstream's setup
require('plugin').setup({ option = "upstream" })

-- Your setup (this one wins!)
require('plugin').setup({ option = "yours" })
```

**Problem:** Last call wins, but both execute. May cause warnings/errors.

**Solution:** Use `mkForce` to ensure only YOUR setup is in init.lua.

```bash
# Check for multiple setup calls
grep -n "require('plugin')\.setup" $ACTUAL_INIT

# Should see only ONE line
```

## Debugging Workflow Script

Save this script to quickly debug conflicts:

```bash
cat > ~/bin/nvf-conflict-check <<'EOF'
#!/usr/bin/env bash
PLUGIN=$1

if [ -z "$PLUGIN" ]; then
  echo "Usage: nvf-conflict-check plugin-name"
  exit 1
fi

echo "=== Checking conflicts for: $PLUGIN ==="

# 1. Find external config
echo -e "\n1. External config source:"
jq -r '.nodes | to_entries[] | select(.key | contains("timvim") or contains("nvim") or contains("astro")) | "\(.key): \(.value.locked.owner)/\(.value.locked.repo)@\(.value.locked.rev[0:7])"' flake.lock

# 2. Check your Nix config
echo -e "\n2. Your Nix config for $PLUGIN:"
grep -A 10 "$PLUGIN" modules/home/nvf/default.nix | head -15

# 3. Find generated init.lua
NVIM_STORE=$(readlink -f $(which nvim) | xargs dirname | xargs dirname)
CONFIG_DIR=$(cat $NVIM_STORE/bin/nvim | grep -oP "(?<=source )[^']+(?='/init.lua')" | xargs dirname)
ACTUAL_INIT=$(cat $CONFIG_DIR/init.lua | grep -oP "(?<=dofile\(')[^']+")

# 4. Check generated Lua
echo -e "\n3. Generated Lua for $PLUGIN:"
grep -B 2 -A 15 "$PLUGIN" $ACTUAL_INIT | head -20

# 5. Count setup calls
echo -e "\n4. Number of setup() calls:"
grep -c "require('$PLUGIN')\.setup" $ACTUAL_INIT || echo "0"

# 6. Runtime check
echo -e "\n5. Runtime config:"
nvim --headless +"lua print(vim.inspect(require('$PLUGIN').state.config or require('$PLUGIN').config or 'NOT FOUND'))" +qa 2>&1 | grep -v "deprecated\|stopped" | head -20
EOF

chmod +x ~/bin/nvf-conflict-check

# Use it
nvf-conflict-check claudecode
```

## Common Patterns

### Pattern 1: Upstream has defaults, you extend

```nix
extraPlugins.plugin.setupOpts = {
  # Upstream sets: { enable = true; mode = "default"; }
  # You add:
  your_option = "value";
  # Result: { enable = true; mode = "default"; your_option = "value"; }
};
```

### Pattern 2: Upstream has setup, you need setupOpts

```nix
# Override their raw setup with your setupOpts
extraPlugins.plugin = {
  setup = lib.mkForce null;  # Clear their raw setup
  setupOpts = {
    # Your structured config
  };
};
```

### Pattern 3: Upstream uses old API, you need new

```nix
# Completely replace with new API
extraPlugins.plugin.setup = lib.mkForce ''
  -- Use new plugin API
  require('plugin').setup_new({
    -- New config structure
  })
'';
```

## Prevention

### Document Your Overrides

```nix
# Good practice: Comment why mkForce is needed
extraPlugins.plugin.setup = lib.mkForce ''
  # Override timvim's config to add 'command' option
  # Upstream: timvim/config/assistant/plugin.nix
  require('plugin').setup({
    command = "${cfg.command}",
  })
'';
```

### Pin External Config Version

```nix
# In flake.nix
inputs.timvim = {
  url = "github:owner/repo/commit-hash";
  # Instead of: "github:owner/repo" (tracks latest)
  flake = false;
};
```

This prevents upstream changes from breaking your config.
