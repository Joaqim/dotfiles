# Tracing setupOpts Through NVF

Deep dive on how NVF processes `setupOpts` vs raw `setup` configurations and how to trace them through the generation pipeline.

## setupOpts vs setup - The Fundamental Difference

### setupOpts (Declarative, NVF-managed)

**What it is:**
- A Nix attribute set that NVF converts to Lua
- NVF handles the `require().setup()` call automatically
- Type-safe and validated by NVF's module system

**Example:**
```nix
extraPlugins.plugin-name.setupOpts = {
  enable = true;
  server = {
    host = "localhost";
    port = 9000;
  };
  command = cfg.myCommand;
};
```

**NVF generates:**
```lua
require('plugin-name').setup({
  enable = true,
  server = {
    host = "localhost",
    port = 9000,
  },
  command = "value-from-cfg",
})
```

### setup (Imperative, Raw Lua)

**What it is:**
- A raw Lua string that you write manually
- You control the exact `require().setup()` call
- Useful for complex config or when setupOpts doesn't support what you need

**Example:**
```nix
extraPlugins.plugin-name.setup = ''
  require('plugin-name').setup({
    enable = true,
    command = "${cfg.myCommand}",
    -- Complex Lua logic
    on_attach = function(client, bufnr)
      -- Custom Lua code here
    end,
  })
'';
```

**NVF uses this verbatim** - it's inserted directly into init.lua.

## When setupOpts Doesn't Work

### Scenario 1: Plugin Doesn't Support setupOpts

Some plugins in NVF's ecosystem don't have setupOpts defined.

**Check:**
```bash
# Look for the plugin in NVF's modules
nix eval --raw .#homeConfigurations.$(whoami)@$(hostname).config.programs.nvf --apply 'x: x.vim.extraPlugins' | grep plugin-name
```

**Solution:** Use raw `setup` instead.

### Scenario 2: Complex Lua Functions

setupOpts can't represent Lua functions or complex logic.

**Problem:**
```nix
# This WON'T work - can't represent Lua function in Nix attrset
setupOpts = {
  on_attach = ???;  # How to write a Lua function here?
};
```

**Solution:** Use raw `setup`:
```nix
setup = ''
  require('plugin').setup({
    on_attach = function(client, bufnr)
      -- Your Lua code
    end,
  })
'';
```

### Scenario 3: Conditional Lua Logic

**Problem:**
```nix
# setupOpts is static - can't have runtime Lua conditions
setupOpts = {
  option = ???;  # Want: vim.fn.has('mac') ? 'value1' : 'value2'
};
```

**Solution:**
```nix
setup = ''
  require('plugin').setup({
    option = vim.fn.has('mac') == 1 and 'value1' or 'value2',
  })
'';
```

## Tracing setupOpts Through the Pipeline

### Step 1: Nix Declaration

**File:** `modules/home/nvf/default.nix`
```nix
extraPlugins.my-plugin.setupOpts = {
  command = cfg.myCommand;
  enable = true;
};
```

### Step 2: NVF Module Processing

NVF reads your setupOpts and converts it to Lua.

**Check the NVF module definition:**
```bash
# Find how NVF defines this plugin
nix eval --json .#homeConfigurations.$(whoami)@$(hostname).config.programs.nvf.settings.vim.extraPlugins.my-plugin --show-trace
```

### Step 3: Generated Lua

**File:** `/nix/store/xxx-init.lua`

```lua
-- SECTION: extraPluginConfigs
-- SECTION: my-plugin
require('my-plugin').setup({
  command = "value-from-cfg",
  enable = true,
})
```

**Verify:**
```bash
ACTUAL_INIT=$(cat $(cat $(readlink -f $(which nvim)) | grep -oP "(?<=source )[^']+(?='/init.lua')") | grep -oP "(?<=dofile\(')[^']+")
grep -A 10 "SECTION: my-plugin" $ACTUAL_INIT
```

### Step 4: Plugin Execution

When nvim starts, the setup() call executes and the plugin stores config.

**Runtime check:**
```bash
nvim --headless +"lua print(vim.inspect(require('my-plugin').state.config))" +qa 2>&1
```

## Debugging setupOpts Not Applying

### Checklist

- [ ] **Rebuilt home-manager?** Run `task hm -f`
- [ ] **nvim store path changed?** Old package = no rebuild happened
- [ ] **Restarted nvim?** Old instances use old config
- [ ] **Generated Lua correct?** Check `$ACTUAL_INIT`
- [ ] **Runtime state correct?** Check `require('plugin').state.config`

### Detailed Tracing

```bash
# 1. Check Nix declaration
cat modules/home/nvf/default.nix | grep -A 10 "my-plugin"

# 2. Rebuild and capture output
task hm -f 2>&1 | tee /tmp/hm-rebuild.log

# 3. Find new nvim package
NEW_NVIM=$(readlink -f $(which nvim))
echo "New nvim: $NEW_NVIM"

# 4. Extract and read generated config
CONFIG_DIR=$(cat $NEW_NVIM | grep -oP "(?<=source )[^']+(?='/init.lua')" | xargs dirname)
ACTUAL_INIT=$(cat $CONFIG_DIR/init.lua | grep -oP "(?<=dofile\(')[^']+")

# 5. Verify your plugin config
grep -B 2 -A 15 "my-plugin" $ACTUAL_INIT

# 6. Check runtime
nvim --headless +"lua local cfg = require('my-plugin').state.config; print('command:', cfg.command, 'enable:', cfg.enable)" +qa 2>&1
```

## Type Conversions: Nix → Lua

### Booleans

**Nix:**
```nix
setupOpts.enable = true;
```

**Generated Lua:**
```lua
enable = true,  -- Lua boolean
```

**For raw setup, manual conversion needed:**
```nix
let
  toLua = b: if b then "true" else "false";
in
setup = ''
  require('plugin').setup({
    enable = ${toLua cfg.enable},
  })
'';
```

### Strings

**Nix:**
```nix
setupOpts.command = "my-command";
setupOpts.interpolated = cfg.myValue;
```

**Generated Lua:**
```lua
command = "my-command",
interpolated = "value-from-cfg",
```

### Nested Attribute Sets

**Nix:**
```nix
setupOpts = {
  server = {
    host = "localhost";
    port = 9000;
  };
};
```

**Generated Lua:**
```lua
server = {
  host = "localhost",
  port = 9000,
},
```

### Lists

**Nix:**
```nix
setupOpts.languages = [ "en" "sv" "de" ];
```

**Generated Lua:**
```lua
languages = { "en", "sv", "de" },
```

## Priority and Overrides

### mkForce for Complete Override

When upstream configs define the same plugin:

```nix
# Without mkForce - might merge or conflict
extraPlugins.plugin.setupOpts = { your = "config"; };

# With mkForce - completely replaces upstream
extraPlugins.plugin.setupOpts = lib.mkForce { your = "config"; };
```

### Checking Effective Priority

```bash
# See what wins after all module merges
nix eval --json .#homeConfigurations.$(whoami)@$(hostname).config.programs.nvf.settings.vim.extraPlugins.plugin.setupOpts
```

## Common Patterns

### Conditional Setup Based on Nix Option

```nix
extraPlugins.plugin.setupOpts = lib.mkIf cfg.enable {
  # Only included if cfg.enable is true
  option = "value";
};
```

### Merging with Upstream Config

```nix
# Add to upstream's setupOpts
extraPlugins.plugin.setupOpts = lib.mkMerge [
  # Upstream's config (if any) is preserved
  { your_additional = "option"; }
];
```

### Complete Replacement of Upstream

```nix
# Throw away upstream, use only your config
extraPlugins.plugin.setupOpts = lib.mkForce {
  option1 = "value1";
  option2 = "value2";
};
```
